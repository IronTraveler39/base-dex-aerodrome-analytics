// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

/// @title VolumeAggregator
/// @notice Minimal contract to store reported daily volume metrics for a DEX (example: Aerodrome)
/// @dev Off-chain collectors (trusted reporter) should call `reportVolume` or `bulkReport`.
contract VolumeAggregator {
    address public owner;
    // map day (unix day number) => volume in base units (e.g., wei)
    mapping(uint256 => uint256) public volumes;
    // allow list of reporters (optional)
    mapping(address => bool) public reporters;

    event OwnerChanged(address indexed oldOwner, address indexed newOwner);
    event ReporterUpdated(address indexed reporter, bool allowed);
    event VolumeReported(uint256 indexed day, uint256 volume, address indexed reporter);

    modifier onlyOwner() {
        require(msg.sender == owner, "only owner");
        _;
    }

    modifier onlyReporterOrOwner() {
        require(msg.sender == owner || reporters[msg.sender], "not authorised");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    /// @notice Transfer contract ownership
    function transferOwnership(address _newOwner) external onlyOwner {
        require(_newOwner != address(0), "zero address");
        address old = owner;
        owner = _newOwner;
        emit OwnerChanged(old, _newOwner);
    }

    /// @notice Set or revoke reporter permission
    function setReporter(address _reporter, bool _allowed) external onlyOwner {
        reporters[_reporter] = _allowed;
        emit ReporterUpdated(_reporter, _allowed);
    }

    /// @notice Report single day's volume (in smallest units, e.g., wei)
    function reportVolume(uint256 day, uint256 volume) external onlyReporterOrOwner {
        volumes[day] = volume;
        emit VolumeReported(day, volume, msg.sender);
    }

    /// @notice Report multiple days in a batch
    function bulkReport(uint256[] calldata days, uint256[] calldata vols) external onlyReporterOrOwner {
        require(days.length == vols.length, "len mismatch");
        for (uint256 i = 0; i < days.length; i++) {
            volumes[days[i]] = vols[i];
            emit VolumeReported(days[i], vols[i], msg.sender);
        }
    }

    /// @notice Get volume for a given day
    function getVolume(uint256 day) external view returns (uint256) {
        return volumes[day];
    }

    /// @notice Sum volumes for several days (read-only)
    function getTotal(uint256[] calldata days) external view returns (uint256 total) {
        for (uint256 i = 0; i < days.length; i++) {
            total += volumes[days[i]];
        }
    }
}
