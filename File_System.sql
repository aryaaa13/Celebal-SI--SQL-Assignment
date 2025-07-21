USE temp;

-- Your CREATE TABLE and INSERT statements go here
CREATE TABLE FileSystem (
    NodeID INT PRIMARY KEY,
    NodeName VARCHAR(255), -- Use VARCHAR for MySQL
    ParentID INT NULL,
    SizeBytes INT NULL
);

INSERT INTO FileSystem (NodeID, NodeName, ParentID, SizeBytes) VALUES
(1, 'Documents', NULL, NULL),
(2, 'Pictures', NULL, NULL),
(3, 'File1.txt', 1, 500),
(4, 'Folder1', 1, NULL),
(5, 'Image.jpg', 2, 1200),
(6, 'Subfolder1', 4, NULL),
(7, 'File2.txt', 4, 750),
(8, 'File3.txt', 6, 300),
(9, 'Folder2', 2, NULL),
(10, 'File4.txt', 9, 250);

-- Your recursive CTE query goes here
WITH RECURSIVE NodeHierarchy AS (
    SELECT
        NodeID,
        NodeName,
        ParentID,
        COALESCE(SizeBytes, 0) AS IndividualSizeBytes,
        NodeID AS OriginalNodeID
    FROM
        FileSystem

    UNION ALL

    SELECT
        fs.NodeID,
        fs.NodeName,
        fs.ParentID,
        nh.IndividualSizeBytes,
        nh.OriginalNodeID
    FROM
        FileSystem fs
    JOIN
        NodeHierarchy nh ON fs.NodeID = nh.ParentID
)
SELECT
    fs.NodeID,
    fs.NodeName,
    SUM(nh.IndividualSizeBytes) AS SizeBytes
FROM
    FileSystem fs
JOIN
    NodeHierarchy nh ON fs.NodeID = nh.OriginalNodeID
GROUP BY
    fs.NodeID,
    fs.NodeName
ORDER BY
    fs.NodeID;