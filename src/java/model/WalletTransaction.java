package model;

import java.math.BigDecimal;
import java.sql.Timestamp;

public class WalletTransaction {

    private int transactionId;
    private BigDecimal amount;
    private String transactionType;
    private String description;
    private Timestamp createdAt;
    private Integer relatedBookingTransactionId;

    public WalletTransaction(int transactionId, BigDecimal amount, String transactionType, String description,
            Timestamp createdAt, Integer relatedBookingTransactionId) {
        this.transactionId = transactionId;
        this.amount = amount;
        this.transactionType = transactionType;
        this.description = description;
        this.createdAt = createdAt;
        this.relatedBookingTransactionId = relatedBookingTransactionId;
    }

    // Getters
    public int getTransactionId() {
        return transactionId;
    }

    public BigDecimal getAmount() {
        return amount;
    }

    public String getTransactionType() {
        return transactionType;
    }

    public String getDescription() {
        return description;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public Integer getRelatedBookingTransactionId() {
        return relatedBookingTransactionId;
    }
}
