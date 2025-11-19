package com.aialpha.sentiment.metrics;

import io.micrometer.core.instrument.*;
import org.springframework.stereotype.Component;

import java.util.concurrent.TimeUnit;
import java.util.concurrent.atomic.AtomicInteger;

@Component
public class SentimentMetrics {

    private final MeterRegistry meterRegistry;

    private final AtomicInteger compDetectedGauge;

    // Constructor injection of MeterRegistry
    public SentimentMetrics(MeterRegistry meterRegistry) {
        this.meterRegistry = meterRegistry;
        this.compDetectedGauge = new AtomicInteger(0);
        Gauge.builder("sentiment.analysis.companies.detected", compDetectedGauge, AtomicInteger::get)
                .description("Number of companies detected in last analysis")
                .register(meterRegistry);
    }

    /**
     * Example implementation: Counter for sentiment analysis requests
     * This counter tracks the total number of sentiment analyses by sentiment type and company
     */
    public void recordAnalysis(String sentiment, String company) {
        Counter.builder("sentiment.analysis.total")
                .tag("sentiment", sentiment)
                .tag("company", company)
                .description("Total number of sentiment analysis requests")
                .register(meterRegistry)
                .increment();
    }

    public void recordDuration(long milliseconds, String company, String model) {
        Timer.builder("sentiment.analysis.duration")
                .tag("company", company)
                .tag("model", model)
                .description("Duration of analysis")
                .register(meterRegistry)
                .record(milliseconds, TimeUnit.MILLISECONDS);
    }

    public void recordCompaniesDetected(int count) {
        compDetectedGauge.set(count);
    }

    public void recordConfidence(double confidence, String sentiment, String company) {
        DistributionSummary.builder("sentiment.analysis.confidence")
                .tag("sentiment", sentiment)
                .baseUnit("score")
                .tag("company", company)
                .description("Distribution of confidence scores from sentiment analysis")
                .register(meterRegistry)
                .record(confidence);
    }
}
