package model;

import java.math.BigDecimal;
import java.sql.Timestamp;

public class Wallet {

    private int walletId;
    private int ownerId;
    private String ownerType;
    private BigDecimal balance;
    private Timestamp lastUpdatedAt;

    public Wallet(int walletId, int ownerId, String ownerType, BigDecimal balance, Timestamp lastUpdatedAt) {
        this.walletId = walletId;
        this.ownerId = ownerId;
        this.ownerType = ownerType;
        this.balance = balance;
        this.lastUpdatedAt = lastUpdatedAt;
    }

    // Getters và Setters
    public int getWalletId() {
        return walletId;
    }

    public void setWalletId(int walletId) {
        this.walletId = walletId;
    }

    public int getOwnerId() {
        return ownerId;
    }

    public void setOwnerId(int ownerId) {
        this.ownerId = ownerId;
    }

    public String getOwnerType() {
        return ownerType;
    }

    public void setOwnerType(String ownerType) {
        this.ownerType = ownerType;
    }

    public BigDecimal getBalance() {
        return balance;
    }

    public void setBalance(BigDecimal balance) {
        this.balance = balance;
    }

    public Timestamp getLastUpdatedAt() {
        return lastUpdatedAt;
    }

    public void setLastUpdatedAt(Timestamp lastUpdatedAt) {
        this.lastUpdatedAt = lastUpdatedAt;
    }
}
