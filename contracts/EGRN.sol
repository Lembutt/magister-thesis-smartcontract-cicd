// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


contract EGRN {
    address public owner;
    string public name = "EGRN";
    mapping (string => bool) objects;
    mapping (string => bytes32) records;

    constructor() {
        owner = msg.sender;
    }
    
    modifier onlyOwner() {
        require(msg.sender == owner, "NOT AUTHORIZED");
        _;
    }

    function getEgrnRecordHash(
        string memory objectId,
        string memory egrnRecordId,
        string memory egrnRecord
    ) private pure returns (bytes32 hash) {
        hash = keccak256(
            abi.encodePacked(
                objectId, 
                egrnRecordId, 
                egrnRecord));
    }

    function createNewObject(
        string memory objectId
    ) private {
        objects[objectId] = true;
    }

    function createNewRecord(
        string memory objectId,
        string memory egrnRecordId,
        string memory egrnRecord
    ) private returns (bytes32 recordHash) {
        recordHash = getEgrnRecordHash(objectId, egrnRecordId, egrnRecord);
        records[egrnRecordId] = recordHash;
    }

    function addNewObject(
        string memory objectId, 
        string memory egrnRecordId,
        string memory egrnRecord
    ) public onlyOwner() returns(bytes32 recordHash) {
        bool objectExists = checkObjectExistance(objectId);
        if (objectExists) revert(unicode'Объект с таким идентификатором уже существует');
        bool recordExists = checkRecordExistance(egrnRecordId);
        if (recordExists) revert(unicode'Запись с таким идентификатором уже существует');
        createNewObject(objectId);
        recordHash = createNewRecord(objectId, egrnRecordId, egrnRecord); 
    }

    function addNewRecord(
        string memory objectId, 
        string memory egrnRecordId,
        string memory egrnRecord
    ) public onlyOwner() returns (bytes32 recordHash) {
        bool objectExists = checkObjectExistance(objectId);
        if (!objectExists) revert(unicode'Объекта с таким идентификатором не существует');
        bool recordExists = checkRecordExistance(egrnRecordId);
        if (recordExists) revert(unicode'Запись с таким идентификатором уже существует');
        recordHash = createNewRecord(objectId, egrnRecordId, egrnRecord); 
    }

    function checkObjectExistance(
        string memory objectId
    ) private view returns (bool exists) {
        exists = objects[objectId];
    }

    function checkRecordExistance(
        string memory egrnRecordId
    ) private view returns (bool exists) {
        // существует ли запись в реестре
        exists = records[egrnRecordId] != 0x0000000000000000000000000000000000000000000000000000000000000000;
    }

    function checkRecordIdentity(
        string memory objectId,
        string memory egrnRecordId,
        string memory egrnRecord
    ) public view returns (bool identity) {
        bytes32 inputRecordHash = getEgrnRecordHash(objectId, egrnRecordId, egrnRecord);
        identity = inputRecordHash == records[egrnRecordId];
    }
}