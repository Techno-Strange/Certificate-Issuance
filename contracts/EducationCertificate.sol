// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract EducationCertificate {

    address public owner;

    // Structure to hold certificate information
    struct Certificate {
        uint id;
        address student;
        string course;
        string issueDate;
        bool isValid;
    }

    // Mapping from certificate ID to Certificate struct
    mapping(uint => Certificate) public certificates;
    // Counter for certificate IDs
    uint public certificateCount;

    // Event to be emitted when a certificate is issued
    event CertificateIssued(uint indexed certificateId, address indexed student, string course, string issueDate);
    // Event to be emitted when a certificate is revoked
    event CertificateRevoked(uint indexed certificateId);

    constructor() {
        owner = msg.sender; // Set the contract creator as the owner
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can perform this action");
        _;
    }

    modifier certificateExists(uint _certificateId) {
        require(certificates[_certificateId].id == _certificateId, "Certificate does not exist");
        _;
    }

    modifier isValidCertificate(uint _certificateId) {
        require(certificates[_certificateId].isValid, "Certificate is not valid or has been revoked");
        _;
    }

    // Function to issue a new certificate
    function issueCertificate(address _student, string calldata _course, string calldata _issueDate) external onlyOwner {
        certificateCount++;
        certificates[certificateCount] = Certificate(certificateCount, _student, _course, _issueDate, true);
        emit CertificateIssued(certificateCount, _student, _course, _issueDate);
    }

    // Function to revoke a certificate
    function revokeCertificate(uint _certificateId) external onlyOwner certificateExists(_certificateId) {
        certificates[_certificateId].isValid = false;
        emit CertificateRevoked(_certificateId);
    }

    // Function to verify a certificate
    function verifyCertificate(uint _certificateId) external view certificateExists(_certificateId) isValidCertificate(_certificateId) returns (address student, string memory course, string memory issueDate) {
        Certificate memory cert = certificates[_certificateId];
        return (cert.student, cert.course, cert.issueDate);
    }

    // Function to get certificate details
    function getCertificate(uint _certificateId) external view certificateExists(_certificateId) returns (address student, string memory course, string memory issueDate, bool isValid) {
        Certificate memory cert = certificates[_certificateId];
        return (cert.student, cert.course, cert.issueDate, cert.isValid);
    }
}