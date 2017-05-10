**File-ingestor** is a tool that automatically and continuously monitors folders on the filesystem and synchronizes them with an AWS S3 bucket. The tool supports monitoring mulitiple file paths on the local filesystem. The heavy lifting in the tool is performed by the AWS CLI. Synchronization is performed on a near continuous basis through job scheduling. The tool currently only supports Windows, but we expect to add a version for Linux.

Prerequisites
============
The configuration of file-ingestor requires AWS keys, the name of a bucket, the region where your bucket is, and the path from which you want to ingest. So, you should do the following before download and installation:
* Know your AWS access key id and secret. We recommend creating a distinct user for this purpose and limiting access solely to the S3 bucket
* Have created the S3 bucket
* Configured your user in IAM to have access to the S3 bucket only. For example,
```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "s3:*",
            "Resource": "arn:aws:s3:::file-ingestor-proto/*"
        }
    ]
}
```

Installation varies by your target system operating system:
* [Windows installation](Windows/README.md)
* Linux installation (planned)
