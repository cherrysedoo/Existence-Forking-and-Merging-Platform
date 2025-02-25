import { describe, it, beforeEach, expect } from "vitest"

describe("Reality Snapshot Contract", () => {
  let mockStorage: Map<string, any>
  let nextSnapshotId: number
  
  beforeEach(() => {
    mockStorage = new Map()
    nextSnapshotId = 0
  })
  
  const mockContractCall = (method: string, args: any[] = []) => {
    switch (method) {
      case "create-snapshot":
        const [universeHash] = args
        nextSnapshotId++
        mockStorage.set(`snapshot-${nextSnapshotId}`, {
          universe_hash: universeHash,
          timestamp: 0,
          creator: "tx-sender",
        })
        return { success: true, value: nextSnapshotId }
      case "get-snapshot":
        return { success: true, value: mockStorage.get(`snapshot-${args[0]}`) }
      case "get-latest-snapshot-id":
        return { success: true, value: nextSnapshotId }
      default:
        return { success: false, error: "Unknown method" }
    }
  }
  
  it("should create a new snapshot", () => {
    const result = mockContractCall("create-snapshot", ["0x1234567890abcdef"])
    expect(result.success).toBe(true)
    expect(result.value).toBe(1)
  })
  
  it("should get snapshot information", () => {
    mockContractCall("create-snapshot", ["0x1234567890abcdef"])
    const result = mockContractCall("get-snapshot", [1])
    expect(result.success).toBe(true)
    expect(result.value).toEqual({
      universe_hash: "0x1234567890abcdef",
      timestamp: 0,
      creator: "tx-sender",
    })
  })
  
  it("should get the latest snapshot id", () => {
    mockContractCall("create-snapshot", ["0x1234567890abcdef"])
    mockContractCall("create-snapshot", ["0xabcdef1234567890"])
    const result = mockContractCall("get-latest-snapshot-id")
    expect(result.success).toBe(true)
    expect(result.value).toBe(2)
  })
})

