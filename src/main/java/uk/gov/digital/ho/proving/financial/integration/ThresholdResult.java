package uk.gov.digital.ho.proving.financial.integration;

import com.fasterxml.jackson.annotation.JsonCreator;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.annotation.JsonProperty;
import uk.gov.digital.ho.proving.financial.model.CappedValues;
import uk.gov.digital.ho.proving.financial.model.ResponseDetails;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Objects;

/**
 * @Author Home Office Digital
 */
@JsonIgnoreProperties(ignoreUnknown = true)
public final class ThresholdResult implements Serializable {

    private final BigDecimal threshold;

    private final CappedValues cappedValues;

    @JsonInclude(JsonInclude.Include.NON_NULL)
    private final ResponseDetails status;


    @JsonCreator
    public ThresholdResult(@JsonProperty("threshold") BigDecimal threshold,
                           @JsonProperty("cappedValues") CappedValues cappedValues,
                           @JsonProperty("status") ResponseDetails status){
        this.threshold = threshold;
        this.cappedValues = cappedValues;
        this.status = status;
    }

    public BigDecimal getThreshold() {
        return threshold;
    }

    public CappedValues getCappedValues() {
        return cappedValues;
    }

    public ResponseDetails getStatus() {
        return status;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        ThresholdResult that = (ThresholdResult) o;
        return Objects.equals(threshold, that.threshold) &&
            Objects.equals(status, that.status) &&
            Objects.equals(cappedValues, that.cappedValues);
    }

    @Override
    public int hashCode() {
        return Objects.hash(threshold, status, cappedValues);
    }

    @Override
    public String toString() {
        return "ThresholdResult{" +
            "threshold=" + threshold +
            ", cappedValues=" + cappedValues +
            ", status=" + status +
            '}';
    }
}
