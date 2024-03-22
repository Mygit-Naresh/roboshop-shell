#!/bin/bash
aws ec2 run-instances --image-id ami-0f3c7d07486cad139 --count 2 --instance-type t2.micro --security-group-ids sg-09806393e77f11a3e