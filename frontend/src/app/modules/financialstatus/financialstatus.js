/* global angular _ moment ga */

/* jshint node: true */

'use strict'

var financialstatusModule = angular.module('hod.financialstatus', ['ui.router'])

financialstatusModule.factory('FinancialstatusService', ['IOService', '$state', '$timeout', 'CONFIG', '$window', function (IOService, $state, $timeout, CONFIG, $window) {
  var me = this
  var finStatus
  var isValid = false
  var lastAPIresponse

  this.isCalc = true

  this.reset = function () {
    isValid = false
    lastAPIresponse = null
    finStatus = this.getBlank()
  }

  // get the form details
  this.getDetails = function () {
    return finStatus
  }

  // get the defaults
  this.getBlank = function () {
    return {
      continuationCourse: null,
      applicationRaisedDate: '',
      studentType: '',
      toDate: '',
      inLondon: null,
      originalCourseStartDate: '',
      courseStartDate: '',
      courseEndDate: '',
      totalTuitionFees: '',
      tuitionFeesAlreadyPaid: '',
      accommodationFeesAlreadyPaid: '',
      numberOfDependants: '',
      sortCode: '',
      accountNumber: '',
      dob: ''
    }
  }

  this.getCourseTypeOptions = function () {
    return [
      { label: 'Pre-sessional', value: 'pre-sessional' },
      { label: 'Main', value: 'main' }
    ]
  }

  // get the available types
  this.getStudentTypes = function () {
    return [
      {
        value: 'nondoctorate',
        label: 'General student',
        full: 'Tier 4 (General) student',
        hiddenFields: [],
        noDependantsOnCourseLength: 6
      },
      {
        value: 'doctorate',
        label: 'Doctorate extension scheme',
        full: 'Tier 4 (General) student (doctorate extension scheme)',
        hiddenFields: [
          'courseType',
          'courseStartDate',
          'courseEndDate',
          'totalTuitionFees',
          'tuitionFeesAlreadyPaid',
          'continuationCourse',
          'originalCourseStartDate'
        ],
        noDependantsOnCourseLength: null
      },
      {
        value: 'pgdd',
        label: 'Postgraduate doctor or dentist',
        full: 'Tier 4 (General) student (postgraduate doctor or dentist)',
        hiddenFields: [
          'courseType',
          'totalTuitionFees',
          'tuitionFeesAlreadyPaid',
          'continuationCourse',
          'originalCourseStartDate'
        ],
        noDependantsOnCourseLength: null
      },
      {
        value: 'sso',
        label: 'Student union sabbatical officer',
        full: 'Tier 4 (General) student union (sabbatical officer)',
        hiddenFields: [
          'courseType',
          'totalTuitionFees',
          'tuitionFeesAlreadyPaid',
          'continuationCourse',
          'originalCourseStartDate'
        ],
        noDependantsOnCourseLength: null
      }
    ]
  }

  // get the config detail of the student given the typ code eg sso fo Student union sabbatical officer
  this.getStudentTypeByID = function (typ) {
    return _.findWhere(me.getStudentTypes(), { value: typ })
  }

  // set form the validation status
  this.setValid = function (bool) {
    isValid = (bool) ? true : false
  }

  // get the form validation state
  this.getValid = function () {
    return isValid
  }

  // determine the course length given start and end dates
  this.getCourseLength = function () {
    if (finStatus.studentType === 'doctorate') {
      return 2
    }

    var from, to
    from = finStatus.courseStartDate
    to = finStatus.courseEndDate

    return me.getMonths(from, to)
  }

  this.getEntireCourseLength = function () {
    if (finStatus.studentType === 'doctorate') {
      return 2
    }

    var to = finStatus.courseEndDate
    var from = finStatus.courseStartDate
    if (finStatus.originalCourseStartDate) {
      from = finStatus.originalCourseStartDate
    }
    return me.getMonths(from, to)
  }

  this.getMonths = function (start, end) {
    start = moment(start, 'YYYY-MM-DD', true)
    end = moment(end, 'YYYY-MM-DD', true)
    var months = end.diff(start, 'months', true)
    if (start.date() === end.date() && !start.isSame(end)) {
      // when using moment diff months, the same day in months being compared
      // rounds down the months
      // eg 1st June to 1st July equals 1 month, NOT 1 month and 1 day which is the result we want
      // therefore if the start and end days are equal add a day onto the month.
      months += 1 / 31
    }
    return months
  }

  // send the API request
  this.sendDetails = function () {
    if (!isValid) {
      // we only want to send details when the form is valid
      return
    }

    finStatus.courseLength = Math.ceil(me.getCourseLength())
    finStatus.entireCourseLength = Math.ceil(me.getEntireCourseLength())

    // make a copy of the finStatus object and delete fields we don't want to send
    var details = angular.copy(finStatus)
    var sortCode = details.sortCode
    var accountNumber = details.accountNumber
    var resultUrl = 'financialStatusResults'

    if (this.isCalc) {
      sortCode = '010616'
      accountNumber = '00030000'
      details.dob = '1974-05-13'
      resultUrl = 'financialStatusCalcResults'
    }

    delete details.applicationRaisedDate
    delete details.sortCode
    delete details.accountNumber

    if (details.continuationCourse !== 'yes') {
      delete details.originalCourseStartDate
    }
    delete details.continuationCourse

    var stud = this.getStudentTypeByID(finStatus.studentType)
    _.each(stud.hiddenFields, function (f) {
      delete details[f]
    })

    var url = sortCode + '/' + accountNumber + '/dailybalancestatus'
    var attemptNum = 0

    var trySendDetails = function () {
      attemptNum++

      IOService.get(url, details, { timeout: CONFIG.timeout }).then(function (result) {
        lastAPIresponse = result.data
        lastAPIresponse.responseTimeStamp = new Date()
        $state.go(resultUrl, {studentType: finStatus.studentType})
      }, function (err) {
        if (err.status === -1 && attemptNum < CONFIG.retries) {
          trySendDetails()
          return
        }

        if (err.status === -1) {
          $window.location.reload()
          return
        }

        lastAPIresponse = {
          failureReason: {
            status: err.status
          }
        }
        $state.go(resultUrl, {studentType: finStatus.studentType})
      })
    }
    // start attempting to make the request
    trySendDetails()
  }

  this.getResponse = function () {
    return lastAPIresponse
  }

  this.trackFormSubmission = function (frm) {
    var errcount = 0
    var errcountstring = ''
    _.each(frm.objs, function (o) {
      if (o.error && o.error.msg) {
        errcount++
        ga('send', 'event', frm.name, 'validation', o.config.id)
      }
    })
    errcountstring = '' + errcount
    while (errcountstring.length < 3) {
      errcountstring = '0' + errcountstring
    }
    ga('send', 'event', frm.name, 'errorcount', errcountstring)
  }

  // on first run set status to blank
  finStatus = this.getBlank()

  return this
}])

