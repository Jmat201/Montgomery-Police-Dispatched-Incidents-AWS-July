# Montgomery-Police-Dispatched-Incidents-AWS-June
### Montgomery County, Maryland (MD) Police Dispatched Incidents: June 2024
A Project done in AWS based on Montgomery County, Maryland (MD) Police Dispatched Incidents in June 2024.

## Description
Montgomery County, Maryland (MD) Police Dispatched Incidents: June 2024.  
This Data Engineering project was built based on the course [Build your first Serverless Data Engineering Project](https://maven.com/david-freitag/first-serverless-de-project) on Maven. The project aims to build a fully functional data engineering pipeline, including data ingestion from an external API, performing ETL workflow orchestration, data cleaning, data quality checks, publishing to production, and generating visualizations using Amazon Web Service (AWS) and Grafana.  

The goal of the project is to analyze police dispatched incidents in Montgomery County, MD, to understand patterns of incidents that occur within different cities in Montgomery county along with an open-ended exploration of the data.

## About the Dataset
The dataset is publicly available and provided by Montgomery County, MD. It is updated four times a day and contains a list of Police Dispatch Incidents in Montgomery County.  
- Dataset link: [Police Dispatched Incidents](https://data.montgomerycountymd.gov/Public-Safety/Police-Dispatched-Incidents/98cc-bc7d/about_data)  
- API call: Limited to 1157 records between 10 June to 13 June 2024  
- JSON URL: [Link to JSON](https://data.montgomerycountymd.gov/Public-Safety/Police-Dispatched-Incidents/98cc-bc7d/explore/query/SELECT%0A%20%20%60incident_id%60%2C%0A%20%20%60cr_number%60%2C%0A%20%20%60crash_reports%60%2C%0A%20%20%60start_time%60%2C%0A%20%20%60end_time%60%2C%0A%20%20%60priority%60%2C%0A%20%20%60initial_type%60%2C%0A%20%20%60close_type%60%2C%0A%20%20%60address%60%2C%0A%20%20%60city%60%2C%0A%20%20%60state%60%2C%0A%20%20%60zip%60%2C%0A%20%20%60longitude%60%2C%0A%20%20%60latitude%60%2C%0A%20%20%60police_district_number%60%2C%0A%20%20%60sector%60%2C%0A%20%20%60pra%60%2C%0A%20%20%60calltime_callroute%60%2C%0A%20%20%60calltime_dispatch%60%2C%0A%20%20%60calltime_arrive%60%2C%0A%20%20%60calltime_cleared%60%2C%0A%20%20%60callroute_dispatch%60%2C%0A%20%20%60dispatch_arrive%60%2C%0A%20%20%60arrive_cleared%60%2C%0A%20%20%60disposition_desc%60%2C%0A%20%20%60geolocation%60%2C%0A%20%20%60%3A%40computed_region_6vgr_duib%60%0AWHERE%0A%20%20%60start_time%60%0A%20%20%20%20BETWEEN%20%222024-06-01T00%3A00%3A00%22%20%3A%3A%20floating_timestamp%0A%20%20%20%20AND%20%222024-06-13T11%3A45%3A00%22%20%3A%3A%20floating_timestamp%0AORDER%20BY%20%60end_time%60%20DESC%20NULL%20FIRST/page/filter). To generate a customised json link for the data you need, apply filters on the dateset as you need and click on Export> API endpoint.

## Dataset Fields

| Field                     | Description                                                                                           |
|---------------------------|-------------------------------------------------------------------------------------------------------|
| `incident_id`             | CAD incident number                                                                                   |
| `Crime`                   | Crime reports (number) written for the event                                                          |
| `crash`                   | Crash reports (number) written for the event                                                          |
| `start_time`              | Incident call pickup date/time                                                                        |
| `end_time`                | Last unit cleared date/time                                                                           |
| `priority`                | 0 thru 4 with 0 as the highest priority                                                               |
| `initial_type`            | 159 codes for initial call type                                                                       |
| `close_type`              | Initial call type could change by the end of the call                                                 |
| `address`                 | GIS process to geocode the actual address from the police to the 100 block level address               |
| `city`                    | Mailing address values, not jurisdictions or municipalities                                           |
| `state`                   | State                                                                                                 |
| `zip`                     | Zipcode                                                                                               |
| `longitude`               | Longitude for actual address. GIS to geocode to 100 block level                                       |
| `latitude`                | Latitude for actual address. GIS to geocode to 100 block level                                        |
| `police_district_number`  | Incident location                                                                                     |
| `BEAT(Sector)`            | Incident location                                                                                     |
| `PRA`                     | Incident location                                                                                     |
| `CallTime CallRoute`      | # of seconds from call pickup to data entry start                                                     |
| `CallTime Dispatch`       | # of seconds from call pickup to first unit dispatched                                                |
| `CallTime Arrive`         | # of seconds from call pickup to first unit arrived on-scene                                          |
| `CallTime Cleared`        | # of seconds from call pickup to last unit cleared                                                    |
| `CallRoute Dispatch`      | # of seconds from data entry start to first unit dispatched                                           |
| `Dispatch Arrive`         | # of seconds from first unit dispatched to first unit arrived on-scene                                |
| `Arrive Cleared`          | # of seconds from first unit arrived on-scene to last unit cleared                                    |
| `Disposition Desc`        | Final call disposition from last unit cleared                                                         |
| `Location (geolocation)`  | Location with (longitude, latitude)                                                                   |
| `row_ts`                  | Row timestamp of when the data was extracted from API Lambda function run                             |

## Tech Stack:
- [AWS](https://aws.amazon.com/)- AWS Lamda, S3, AWS Glue, AWS Kinesis, Amazon EC2, AWS IAM, Amazon Firehose, Amazon Athena, AWS CloudWatch.
- SQL
- Python
- [Grafana] (https://grafana.com/)

## Data Engineering Process & Pipeline: 

![Architecture](https://github.com/Jmat201/Montgomery-Police-Dispatched-Incidents-AWS-July/blob/50a924fd61031abda96788302481c46b3ac5c153/Dashboard%20Screenshots%20and%20Images/first_de_project_architecture.png)

1. **Create a Kinesis Firehose**
    - We start by creating a Kinesis Firehose, also known as an "Amazon Data Firehose," and configure it to be ready to receive data. Amazon Kinesis Data Firehose is a serverless streaming/batching data service in AWS that captures data from a source and writes it to an S3 bucket we create, named `montgomery-police-dispatch-incidents`. Note the name of the Kinesis Firehose for use in the next step.

![Kinesis Firehose](https://github.com/Jmat201/Montgomery-Police-Dispatched-Incidents-AWS-July/blob/50a924fd61031abda96788302481c46b3ac5c153/Dashboard%20Screenshots%20and%20Images/Firehose%20stream.png) 

2. **Create a Lambda Function**
    - Next, we create a Lambda Function to push data to the Firehose stream. This Python function includes the Firehose name noted in step 1. The function pulls data from the API URL, stores it in a dictionary with each record from the API, and then creates a new dictionary called `processed_dict` to store the individual fields as strings, with each record in a new line.

![Lamda Function](https://github.com/Jmat201/Montgomery-Police-Dispatched-Incidents-AWS-July/blob/50a924fd61031abda96788302481c46b3ac5c153/Dashboard%20Screenshots%20and%20Images/Lamda%20function.png)

3. **Create an AWS Glue Crawler** 
    - We then create a crawler on AWS Glue Crawler and configure it to crawl our data and create a table in Athena. After configuring the `AWSGlueServiceRole`, we create the crawler. Kinesis automatically partitions data by year/month/hour based on ingestion date, which can be used to increase query efficiency.

![Glue crawler](https://github.com/Jmat201/Montgomery-Police-Dispatched-Incidents-AWS-July/blob/50a924fd61031abda96788302481c46b3ac5c153/Dashboard%20Screenshots%20and%20Images/Glue%20Crawler.png)

4. **ETL Process with Glue Jobs**
    - The next stage in our data engineering pipeline is to Extract, Transform, and Load (ETL) the data through a series of jobs (Glue jobs). These jobs automate the pre-processing of data and create a cleaned version of the raw data for analysis. The Glue jobs are written in Python and execute SQL queries in Athena. For this project, we create four jobs:
        * **Create Glue Job [script]():** Creates a table in S3 `montgomery-police-inc-tbl-pqt-table` to insert all records from the source table `project_montgomery_police_dispatch_incidents`.
        * **Data Quality Check Glue Job[script]():** Counts the number of NULL rows in the `start_time` column. If any rows are NULL, the check returns a number > 0. This checks for null rows in our data.
        * **Publish to Production Glue Job [script]():** Creates a Parquet table in our Athena query results bucket `montgomery_police_inc_data_parquet_tbl`, with all the data from the Parquet table.
        * **Delete Glue Job [script]():** Deletes all objects in the S3 bucket `montgomery-police-inc-tbl-pqt-table`, so that previous records are deleted before running the Lambda function for fresh data ingestion.

    - After creating each Glue job, we run the job. Errors in the Python or SQL scripts will be shown if the job run does not complete, and these errors can be seen in the AWS CloudWatch logs.

5. **Workflow Orchestration in Glue**
    - After creating the Glue jobs, we create a workflow in Glue to orchestrate the jobs. We add a ‘trigger’ before each Glue job to sequence the jobs. The workflow is developed in the following order:
        1. Start the pipeline on demand
        2. Run the Crawler
        3. Trigger Delete Glue Job
        4. Run the Delete Glue Job
        5. Trigger Create Glue Job
        6. Run Create Glue Job
        7. Trigger Data Quality Glue Job
        8. Run the Data Quality Glue Job
        9. Trigger Publish to Production Glue Job
        10. Run the Publish to Production Glue Job

This orchestrated workflow ensures a streamlined and automated ETL process, preparing the data for analysis and visualization.

![Workflow 1](https://github.com/Jmat201/Montgomery-Police-Dispatched-Incidents-AWS-July/blob/50a924fd61031abda96788302481c46b3ac5c153/Dashboard%20Screenshots%20and%20Images/Workflow_1.png)
![Workflow 2](https://github.com/Jmat201/Montgomery-Police-Dispatched-Incidents-AWS-July/blob/50a924fd61031abda96788302481c46b3ac5c153/Dashboard%20Screenshots%20and%20Images/Workflow_2.png)

## Questions this project aims to answer: 

#### Incidents (initial_type) by City and Percentage Comparison

1. Which cities have the highest number of incidents (based on initial_type)?
2. What are the most common incident types (initial_types) in the top 4 cities?
3. What is the percentage distribution of incidents in each city?
    - Does comparing the percentage of the same incident types across different cities reveal any insights?

#### Incidents by Address - Street/Road, Latitude and Longitude, and Geocode

4. Which street or road address has the highest number of incidents?
    - Is there a particular street or road where most incidents occur?
    - How can we break down the address column to group incidents based on location?
5. Plotting incidents using geocodes (longitude and latitude), are there specific areas where incidents are concentrated?
    - Is there a visible pattern of incidents occurring at particular street addresses or locations?
    - Are incidents more frequent around cross junctions or main roads/highways?

#### Disposition Description (disposition_desc) for Top 4 initial_types in top 4 cities

6. What is the most common combination of initial_type and disposition_desc in each of the top 4 cities?
    - Are there any combinations common across all top 4 cities?
7. What are the specific disposition descriptions for the top 4 incident types in each of the top 4 cities?

#### Analyzing Missing Values/empty strings in ‘dispatch_arrive’ and ‘arrive_cleared’

8. Do ‘dispatch_arrive’ and ‘arrive_cleared’ have missing values?
    - Is there a pattern based on the type of incidents, sectors, or police district numbers?
    - Are there any notable patterns in the reporting of these values by different jurisdictions?

#### Time taken (in minutes) to attend an incident - Dispatch Arrive and Arrive Cleared

9. How long does it take **for the first unit to arrive on-scene (Dispatch Arrive)** from dispatch in the top 4 cities for ‘TRAFFIC/TRANSPORTATION INCIDENT’, ‘DISTURBANCE/NUISANCE’, and ‘CHECK WELFARE’?
    - What are the common time ranges for these incidents (0-5 mins, 5-10 mins, etc.)?
    - How does the distribution of response times compare across the cities?

10. How long does it take **to clear an incident (arrive_cleared) from the first unit arriving to the last unit clearing** in the top 4 cities for ‘TRAFFIC/TRANSPORTATION INCIDENT’, ‘DISTURBANCE/NUISANCE’, and ‘CHECK WELFARE’?
    - What are the common time ranges for these incidents (0-5 mins, 5-10 mins, etc.)?
    - How does the distribution of clearance times compare across the cities?

11. Which initial_type and priority combinations have the **worst and best Average Dispatch Arrival Minutes (ADM)** across **Silver Spring, Rockville, Gaithersburg, and Germantown**?
    - How consistent are ADMs for the same incident types and priorities across different cities?

12. Why does **‘Sexual Assault - occurred earlier:3’** have the **highest ADM in Silver Spring** compared to other cities?

13. Which initial_type and priority combinations have the **worst and best Average Clearance Minutes (ACM)** across **Silver Spring, Rockville, Gaithersburg, and Germantown**?
    - How consistent are ACMs for the same incident types and priorities across different cities?

14. Comparing **ADMs for the same incident types and priorities** across **key streets/road address** (e.g., Georgia Ave, Rockville Pike, Colesville Rd, Veirs Mill Rd), which combinations perform worst and best consistently? (street/road address is a derived column)
    - How distorted are ADMs for the same incident types and priorities across these streets?

15. Comparing **ACMs for the same incident types and priorities** across **key streets/road address** (e.g., Georgia Ave, Rockville Pike, Colesville Rd, Veirs Mill Rd), **which combinations perform worst and best consistently?
    - How distorted are ACMs for the same incident types and priorities across these streets?

16. Are there **instances** where **a city has a higher ADM and a higher incident count for a particular initial_type and priority combination**, indicating response challenges?

17. Are there **instances** where **a city has a lower ADM and a higher incident count for a particular initial_type and priority combination**, indicating more efficient response?

#### Comparison of Priority by incident in - Top 4 address and Top 4 cities 

18. Is there a **higher percentage of incidents and priorities** in one city compared to another among the top 4 incident types **in Silver Spring, Rockville, Gaithersburg, and Germantown**?


## Dashboard preview
A snapshot of the Grafana Dashboard can be viewed [here](https://mathewj707.grafana.net/dashboard/snapshot/rrWaIgPYO2pwUy7jrkNm4tNqp2qV5eVW)

Following are screenshots of the dashboard: 

### Incidents (initial_type) by City and percentage comparison 
![Dashboard 1](https://github.com/Jmat201/Montgomery-Police-Dispatched-Incidents-AWS-July/blob/50a924fd61031abda96788302481c46b3ac5c153/Dashboard%20Screenshots%20and%20Images/1.png)
![Dashboard 2](https://github.com/Jmat201/Montgomery-Police-Dispatched-Incidents-AWS-July/blob/50a924fd61031abda96788302481c46b3ac5c153/Dashboard%20Screenshots%20and%20Images/2.png)
![Dashboard 2.2](https://github.com/Jmat201/Montgomery-Police-Dispatched-Incidents-AWS-July/blob/50a924fd61031abda96788302481c46b3ac5c153/Dashboard%20Screenshots%20and%20Images/2.2.png)
![Dashboard 3](https://github.com/Jmat201/Montgomery-Police-Dispatched-Incidents-AWS-July/blob/50a924fd61031abda96788302481c46b3ac5c153/Dashboard%20Screenshots%20and%20Images/3.png)
![Dashboard 4](https://github.com/Jmat201/Montgomery-Police-Dispatched-Incidents-AWS-July/blob/50a924fd61031abda96788302481c46b3ac5c153/Dashboard%20Screenshots%20and%20Images/4.png)
![Dashboard 5](https://github.com/Jmat201/Montgomery-Police-Dispatched-Incidents-AWS-July/blob/50a924fd61031abda96788302481c46b3ac5c153/Dashboard%20Screenshots%20and%20Images/5.png)
![Dashboard 6](https://github.com/Jmat201/Montgomery-Police-Dispatched-Incidents-AWS-July/blob/50a924fd61031abda96788302481c46b3ac5c153/Dashboard%20Screenshots%20and%20Images/6.png)
![Dashboard 7](https://github.com/Jmat201/Montgomery-Police-Dispatched-Incidents-AWS-July/blob/50a924fd61031abda96788302481c46b3ac5c153/Dashboard%20Screenshots%20and%20Images/7.png)

### Incidents by Address - (street and Road), Latitude, Longitude and Geocode

![Dashboard 8](https://github.com/Jmat201/Montgomery-Police-Dispatched-Incidents-AWS-July/blob/50a924fd61031abda96788302481c46b3ac5c153/Dashboard%20Screenshots%20and%20Images/8.png)
Map of Incidents in Silver Spring
![Dashboard 9](https://github.com/Jmat201/Montgomery-Police-Dispatched-Incidents-AWS-July/blob/8bd0385ac4571bbd6f29af1fadbf9292892728f6/Dashboard%20Screenshots%20and%20Images/9.png)
Non-Traffic/Transportation Incidents in Silver Spring
![Dashboard 9.1](https://github.com/Jmat201/Montgomery-Police-Dispatched-Incidents-AWS-July/blob/8bd0385ac4571bbd6f29af1fadbf9292892728f6/Dashboard%20Screenshots%20and%20Images/9.1.png)
Incidents on Gerogia Avenue, Silver Spring
![Dashboard 10](https://github.com/Jmat201/Montgomery-Police-Dispatched-Incidents-AWS-July/blob/8bd0385ac4571bbd6f29af1fadbf9292892728f6/Dashboard%20Screenshots%20and%20Images/10.png)
![Dashboard 11](https://github.com/Jmat201/Montgomery-Police-Dispatched-Incidents-AWS-July/blob/50a924fd61031abda96788302481c46b3ac5c153/Dashboard%20Screenshots%20and%20Images/11.png)
Incidents on Rockville Pike, Rockville
![Dashboard 12](https://github.com/Jmat201/Montgomery-Police-Dispatched-Incidents-AWS-July/blob/8bd0385ac4571bbd6f29af1fadbf9292892728f6/Dashboard%20Screenshots%20and%20Images/12.png)
![Dashboard 13](https://github.com/Jmat201/Montgomery-Police-Dispatched-Incidents-AWS-July/blob/50a924fd61031abda96788302481c46b3ac5c153/Dashboard%20Screenshots%20and%20Images/13.png)
Incidents on Veirs Mill Rd, Rockville
![Dashboard 14](https://github.com/Jmat201/Montgomery-Police-Dispatched-Incidents-AWS-July/blob/8bd0385ac4571bbd6f29af1fadbf9292892728f6/Dashboard%20Screenshots%20and%20Images/14.png)
![Dashboard 15](https://github.com/Jmat201/Montgomery-Police-Dispatched-Incidents-AWS-July/blob/50a924fd61031abda96788302481c46b3ac5c153/Dashboard%20Screenshots%20and%20Images/15.png)
Incidents on Colesville Rd, Silver Spring
![Dashboard 16](https://github.com/Jmat201/Montgomery-Police-Dispatched-Incidents-AWS-July/blob/8bd0385ac4571bbd6f29af1fadbf9292892728f6/Dashboard%20Screenshots%20and%20Images/16.png)
![Dashboard 17](https://github.com/Jmat201/Montgomery-Police-Dispatched-Incidents-AWS-July/blob/50a924fd61031abda96788302481c46b3ac5c153/Dashboard%20Screenshots%20and%20Images/17.png)

### Disposition Description - of top incidents in Top 4 cities  
![Dashboard 18](https://github.com/Jmat201/Montgomery-Police-Dispatched-Incidents-AWS-July/blob/50a924fd61031abda96788302481c46b3ac5c153/Dashboard%20Screenshots%20and%20Images/18.png)
![Dashboard 19](https://github.com/Jmat201/Montgomery-Police-Dispatched-Incidents-AWS-July/blob/50a924fd61031abda96788302481c46b3ac5c153/Dashboard%20Screenshots%20and%20Images/19.png)
![Dashboard 20](https://github.com/Jmat201/Montgomery-Police-Dispatched-Incidents-AWS-July/blob/50a924fd61031abda96788302481c46b3ac5c153/Dashboard%20Screenshots%20and%20Images/20.png)
![Dashboard 21](https://github.com/Jmat201/Montgomery-Police-Dispatched-Incidents-AWS-July/blob/50a924fd61031abda96788302481c46b3ac5c153/Dashboard%20Screenshots%20and%20Images/21.png)

### Analyzing empty strings in ‘dispatch_arrive’ and ‘arrive-_cleared’ 
![Dashboard 22](https://github.com/Jmat201/Montgomery-Police-Dispatched-Incidents-AWS-July/blob/50a924fd61031abda96788302481c46b3ac5c153/Dashboard%20Screenshots%20and%20Images/22.png)
![Dashboard 23](https://github.com/Jmat201/Montgomery-Police-Dispatched-Incidents-AWS-July/blob/50a924fd61031abda96788302481c46b3ac5c153/Dashboard%20Screenshots%20and%20Images/23.png)
![Dashboard 24](https://github.com/Jmat201/Montgomery-Police-Dispatched-Incidents-AWS-July/blob/50a924fd61031abda96788302481c46b3ac5c153/Dashboard%20Screenshots%20and%20Images/24.png)

### Time taken (in minutes) to attend an incident - Dispatch Arrive and Arrive Cleared
![Dashboard 25](https://github.com/Jmat201/Montgomery-Police-Dispatched-Incidents-AWS-July/blob/50a924fd61031abda96788302481c46b3ac5c153/Dashboard%20Screenshots%20and%20Images/25.png)
![Dashboard 26](https://github.com/Jmat201/Montgomery-Police-Dispatched-Incidents-AWS-July/blob/50a924fd61031abda96788302481c46b3ac5c153/Dashboard%20Screenshots%20and%20Images/26.png)
![Dashboard 27](https://github.com/Jmat201/Montgomery-Police-Dispatched-Incidents-AWS-July/blob/50a924fd61031abda96788302481c46b3ac5c153/Dashboard%20Screenshots%20and%20Images/27.png)
![Dashboard 28](https://github.com/Jmat201/Montgomery-Police-Dispatched-Incidents-AWS-July/blob/50a924fd61031abda96788302481c46b3ac5c153/Dashboard%20Screenshots%20and%20Images/28.png)
![Dashboard 29](https://github.com/Jmat201/Montgomery-Police-Dispatched-Incidents-AWS-July/blob/50a924fd61031abda96788302481c46b3ac5c153/Dashboard%20Screenshots%20and%20Images/29.png)
![Dashboard 30](https://github.com/Jmat201/Montgomery-Police-Dispatched-Incidents-AWS-July/blob/50a924fd61031abda96788302481c46b3ac5c153/Dashboard%20Screenshots%20and%20Images/30.png)
![Dashboard 31](https://github.com/Jmat201/Montgomery-Police-Dispatched-Incidents-AWS-July/blob/50a924fd61031abda96788302481c46b3ac5c153/Dashboard%20Screenshots%20and%20Images/31.png)
![Dashboard 32](https://github.com/Jmat201/Montgomery-Police-Dispatched-Incidents-AWS-July/blob/50a924fd61031abda96788302481c46b3ac5c153/Dashboard%20Screenshots%20and%20Images/32.png)
![Dashboard 33](https://github.com/Jmat201/Montgomery-Police-Dispatched-Incidents-AWS-July/blob/50a924fd61031abda96788302481c46b3ac5c153/Dashboard%20Screenshots%20and%20Images/33.png)
![Dashboard 34](https://github.com/Jmat201/Montgomery-Police-Dispatched-Incidents-AWS-July/blob/50a924fd61031abda96788302481c46b3ac5c153/Dashboard%20Screenshots%20and%20Images/34.png)
![Dashboard 35](https://github.com/Jmat201/Montgomery-Police-Dispatched-Incidents-AWS-July/blob/50a924fd61031abda96788302481c46b3ac5c153/Dashboard%20Screenshots%20and%20Images/35.png)
![Dashboard 36](https://github.com/Jmat201/Montgomery-Police-Dispatched-Incidents-AWS-July/blob/50a924fd61031abda96788302481c46b3ac5c153/Dashboard%20Screenshots%20and%20Images/36.png)

### Comparison of Priority by incident in - Top 4 address and Top 4 cities 
![Dashboard 37](https://github.com/Jmat201/Montgomery-Police-Dispatched-Incidents-AWS-July/blob/50a924fd61031abda96788302481c46b3ac5c153/Dashboard%20Screenshots%20and%20Images/37.png)
![Dashboard 38](https://github.com/Jmat201/Montgomery-Police-Dispatched-Incidents-AWS-July/blob/50a924fd61031abda96788302481c46b3ac5c153/Dashboard%20Screenshots%20and%20Images/38.png)
![Dashboard 39](https://github.com/Jmat201/Montgomery-Police-Dispatched-Incidents-AWS-July/blob/50a924fd61031abda96788302481c46b3ac5c153/Dashboard%20Screenshots%20and%20Images/39.png)
![Dashboard 40](https://github.com/Jmat201/Montgomery-Police-Dispatched-Incidents-AWS-July/blob/50a924fd61031abda96788302481c46b3ac5c153/Dashboard%20Screenshots%20and%20Images/40.png)


## Findings

### Incidents (initial_type) by City and Percentage Comparison 
* **(Q1)** In Montgomery County between June 10 and June 13, there were 1,157 incidents reported. The top four cities where incidents occurred were Silver Spring (36%), Rockville (17%), Gaithersburg (13%), and Germantown (9%).
* **(Q2)** Of the 1,157 incidents, 862 (75%) occurred in these four cities. The most common incidents were ‘Traffic/Transportation Incident,’ ‘Suspicious Circumstances, Person, Vehicle,’ ‘Disturbance/Nuisance,’ and ‘Check Welfare.’
* **(Q3)** Comparing the percentage of each of the top 3 incidents in these cities relative to the total incidents in each city, we see:
  - ‘Traffic / Transportation Incident’ is highest in Gaithersburg at 12%, followed by Silver Spring at 9%, and Rockville at 7.5%.
  - ‘Disturbance/Nuisance’ comprises 7.9% of the incidents in Gaithersburg, 6.5% in Rockville, and 5.8% in Silver Spring.
  - ‘Check Welfare’ incidents are 1.5% more prevalent in Gaithersburg than in Germantown.
  - ‘Traffic / Transportation Incident’ is 3% more prevalent in Gaithersburg than in Silver Spring, and 4.5% more than in Rockville.
  - ‘Disturbance/Nuisance’ is 1.4% more prevalent in Gaithersburg than in Rockville.

### Incidents by Address - (Street and Road), Latitude, Longitude, and Geocode

* **(Q4)** To better analyze the precise location of incidents, we need to break up the ‘address’ column into meaningful patterns. Using ‘BLK’ as a separator, we split the address into street or road names. We found that:
  - 3.5% of incidents in Montgomery County occur on ‘Georgia Ave’
  - 1.7% occur on ‘Rockville Pike’
  - 1.5% occur on ‘Veirs Mill Rd’
  - 1.4% occur on ‘Colesville Rd’
  - ‘Georgia Ave,’ ‘Rockville Pike,’ ‘Veirs Mill Rd,’ and ‘Colesville Rd’ are the top 4 street/road addresses where most incidents occur.
  - The most common incidents on these streets are ‘Disturbance/Nuisance,’ ‘Trespassing/Unwanted,’ and ‘Theft/Larceny.’

* **(Q5)** Using latitude and longitude, we can plot each incident on a map. In Silver Spring, most incidents occur at particular highway road crossovers/junctions, such as:
  - ‘Connecticut Ave and Veirs Mill Rd’
  - ‘University Blvd E and Colesville Rd’
  - ‘Georgia Ave and University Blvd W’
  - ‘Colesville Rd and Capital Beltway’
  - ‘Randolph Rd, Layhill Rd, and Georgia Ave’

#### Disposition Description (disposition_desc) for Top 4 initial_types in Top 4 Cities

* **(Q6/7)** The `disposition_desc` field provides finer classification of incidents. Analyzing the combination of `disposition_desc` and `initial_type` for the top 4 `initial_type`s in the top 4 cities, we find:
  - Silver Spring and Germantown have two notable combinations:
    - ‘SUSPICIOUS PERSON/CIRC/PERSON/VEHICLE: SUSPICIOUS SIT/PRSON/VEH’
    - ‘TRAFFIC/TRANSPORTATION INCIDENT: COLLISION-DAMAGE-ROAD-COLLISION’
  - A significantly higher count of these incidents occurs in Silver Spring compared to Rockville, Gaithersburg, and Germantown, possibly due to the higher overall number of incidents in Silver Spring.
  - ‘TRAFFIC/TRANSPORTATION INCIDENT: COLLISION-DAMAGE-ROAD-COLLISION’ is the most common disposition description across all four cities.
  - In Rockville and Gaithersburg, the next two most common combinations are:
    - ‘TRESPASSING/UNWANTED: TRESPASSING’
    - ‘DISTURBANCE/NUISANCE: DISORDERLY CONDUCT’

#### Analyzing Missing Values/Empty Strings in `dispatch_arrive` and `arrive_cleared`

* **(Q8)** During the analysis of Q10-Q13, I found that 292 `incident_id`s had empty `dispatch_arrive` values (not nulls but empty strings), and 273 `incident_id`s had empty strings for `arrive_cleared`. Both fields had empty strings for 273 incidents. There is no clear indication of why these columns are empty based on the sector, beat (pra), or `police_district_number`. However:
  - 22% (61 out of 273 cases) are in `police_district_number` 3D.
  - 15% (41 incidents) are ‘THEFT - TRS THEFT/LARCENY - TELEPHONE REPORTING UNIT,’ while other incident types are at 6% or lower.
  - We need to observe the data for more days to identify patterns in missing data/empty strings related to particular `police_dispatch_numbers`, sectors (beats), or incident types.

We removed all empty string values from the analysis for Q10-Q13.

### Time Taken (in Minutes) to Attend an Incident - Dispatch Arrive and Arrive Cleared

* **(Q9)** Given that ‘Traffic/Transportation Incident,’ ‘Disturbance/Nuisance,’ and ‘Check Welfare’ are the top three most common incidents across the four cities—Silver Spring, Rockville, Gaithersburg, and Germantown—we are analyzing the ‘dispatch_arrive’ and ‘arrive_cleared’ times for these cities:
  - Most ‘Traffic/Transportation Incidents’ take 5-10 minutes for dispatch to arrive in Silver Spring.

* **(Q10)** Comparing the percentages of dispatch arrival time groups in the top 4 cities:
  - 100% of ‘Traffic/Transportation Incidents’ in Germantown have dispatch arrival times of ‘0-5 mins,’ while the same is 33% in Gaithersburg, 40% in Rockville, and 30% in Silver Spring. This could be a concern for Silver Spring, given its high number of incidents and the predominance of ‘Traffic/Transportation Incidents’ in Montgomery County.

  - For ‘Disturbance/Nuisance’ incidents in Silver Spring, police dispatch arrives within 0-5 minutes for 50% of the incidents. In Gaithersburg and Rockville, these figures are 37.5% and 30.8%, respectively. Given that ‘Disturbance/Nuisance’ incidents are the second most frequent in Gaithersburg (5.4%) and Rockville (6.5%), the relatively quicker response in Silver Spring is noteworthy.

  - For ‘Check Welfare’ incidents, 67% of cases are attended to within 5-10 minutes in Gaithersburg. In Silver Spring, only 25% of these incidents are attended to within 0-5 minutes, suggesting that ‘Check Welfare’ may not be a high-priority incident.

  - Overall, Germantown appears to be the most efficient in terms of police dispatch arrival times. This could be due to the lower number of incidents in Germantown.

* **(Q11, Q13)** Comparing the Average Dispatch Minutes (ADM) of the same incident (initial_type) and priority across the top 4 cities—Silver Spring, Rockville, Gaithersburg, and Germantown:
  - We assume the goal for each city is to achieve a lower ADM for each incident and priority. A lower ADM with a higher incident count suggests greater efficiency in handling incidents. Similarly, a lower Average Clearance Minutes (ACM) is desired, although some incidents may naturally require longer clearance times. Higher ACM might indicate thoroughness or longer resolution times.

  Observations:
  - For the following incident_priority combinations, ADM is most efficient in Silver Spring compared to the other cities:
    - ASSAULT:0
    - ASSAULT JUST OCCURRED - ROUTINE 1
    - DISTURBANCE NUISANCE:1
    - DISTURBANCE NUISANCE:2
    - DOMESTIC DISTURBANCE/VIOLENCE - OCCURRED EARLIER:3
    - DOMESTIC DISTURBANCE/VIOLENCE:0
    - DOMESTIC DISTURBANCE/VIOLENCE:1
    - DOMESTIC VIOLENCE:1
    - HARASSMENT, STALKING, THREATS:1
    - SUSPICIOUS CIRC, PERSONS, VEHICLE:1
    - THEFT/LARCENY - OCCURRED EARLIER:4
    - THEFT/LARCENY:2
  - For ‘ALARMRD - ALARM COMMERCIAL BURGLARY/INTRUSION:1’ and ‘ALARMRD - RESIDENTIAL BURGLARY/INTRUSION:1,’ the ADM is worse in Rockville compared to Silver Spring and Gaithersburg.
  - For ‘ANIMAL COMPL:1,’ the ADM is worse in Silver Spring and Gaithersburg but better in Rockville.
  - For ‘FRAUD/DECEPTION - OCCURRED EARLIER:4,’ the ACM is worse in Silver Spring.
  - For ‘MISSING, RUNAWAY, FOUND PERSON:1,’ ACM in Gaithersburg is three times that in Rockville.

| Incident and Priority | ADM (Average Dispatch Arrival Minutes) | ACM (Average Arrival Cleared Minutes) |
|-----------------------|----------------------------------------|---------------------------------------|
| ALARMRB - ALARM COMMERCIAL BURGLARY/INTRUSION:1 | Higher in Rockville by 10 mins compared to Silver Spring and Gaithersburg | |
| ALARMRB - RESIDENTIAL BURGLARY/INTRUSION:1 | Higher in Rockville by twice the time compared to Silver Spring and Gaithersburg | Highest count in Silver Spring yet the highest ACM |
| ANIMAL COMPL:1 | The count of incidents for ANIMAL COMPL:1 is highest in Rockville, and ADM is lowest. In Silver Spring and Gaithersburg, it is three times the time taken in Rockville. | |
| ASSAULT:0, ASSAULT JUST OCCURRED - ROUTINE 1 | Both have the lowest ADM in Silver Spring | |
| CHECK WELFARE:1 | Lowest in Germantown, and the count of incidents is also lowest compared to the 4 cities | |
| DISTURBANCE NUISANCE:1, DISTURBANCE NUISANCE:2 | Highest by count in Silver Spring but lowest in ADM, which is favorable. DISTURBANCE/NUISANCE:2 has the same count of incidents in Silver Spring and Rockville, yet the ACM in Rockville is four times the ACM in Silver Spring. | |
| DOMESTIC DISTURBANCE/VIOLENCE - OCCURRED EARLIER:3, DOMESTIC DISTURBANCE/VIOLENCE:0, DOMESTIC DISTURBANCE/VIOLENCE:1, DOMESTIC VIOLENCE:1 | All are highest in terms of incident count in Silver Spring, yet the ADM is lowest, indicating efficient dispatch units. While ADM for DOMESTIC DISTURBANCE/VIOLENCE:1 in Gaithersburg is very low, the ACM is relatively high at 35 minutes for 4 incidents. | |
| FRAUD/DECEPTION - OCCURRED EARLIER:4 | Has the highest count of incidents in Silver Spring, and the ACM is highest as well. | |
| HARASSMENT, STALKING, THREATS:1 | Highest count of incidents in Silver Spring, yet lowest in ADM | |
| SUSPICIOUS CIRC, PERSONS, VEHICLE:1 | Highest in terms of incident count in Silver Spring, yet has the lowest ADM, indicating that dispatch units in Silver Spring are most efficient in reaching the incident location. | |
| THEFT/LARCENY - OCCURRED EARLIER:4, THEFT/LARCENY:2 | | |
| MISSING, RUNAWAY, FOUND PERSON:1 | The ACM for MISSING, RUNAWAY, FOUND PERSON:1 has the highest count of incidents at 7 in Rockville, yet the ACM is lowest at 25.84. In Gaithersburg, with 3 incidents, the ACM is 72.97, almost three times the ACM in Rockville. | |

* **(Q12)** During the dataset period (June 10-13), there was one incident for ‘SEXUAL ASSAULT - OCCURRED EARLIER:3’ in Silver Spring, Rockville, Gaithersburg, and Germantown. The dispatch arrival time in Silver Spring was 49.3 minutes, significantly longer than in other cities, though this incident was cleared in 81 seconds, suggesting it may be an outlier.

* **(Q14, Q15, Q17)** Comparing the Average Dispatch Minutes (ADM) of the same incident (initial_type) and priority across the most frequent street/road addresses—Georgia Ave, Rockville Pike, Veirs Mill Rd, Colesville Rd:
  - We use the same assumptions as in Q11 and Q13.

| Incident and Priority | ADM (Average Dispatch Arrival Minutes) |
|-----------------------|----------------------------------------|
| CHECK WELFARE:1 | ADM for CHECK WELFARE:1 in Veirs Mill Rd is 7.81 minutes but twice the time taken in Georgia Ave (14.53 minutes) and Rockville (15.54 minutes), despite having the same count of incidents across all three locations. |
| DISTURBANCE/NUISANCE:1 | The ADM for DISTURBANCE/NUISANCE:1 in Georgia Ave is twice the time taken in Colesville Rd, even with the same count of incidents. |
| THEFT/LARCENY:2 | Has a higher count of incidents in Georgia Ave, with ADM more than three times that in other locations with most incidents such as Colesville Rd and Rockville Pike. |
| TRESPASSING/UNWANTED:2 | TRESPASSING/UNWANTED:2 has the highest count of incidents in Rockville Pike with an average ADM of 41.7 minutes, while in Georgia Ave, it is one-eighth of that time. |

* **(Q18)** Comparing the percentage of Priority and initial_type combinations for the top 4 initial_types in each of the four cities—Silver Spring, Rockville, Gaithersburg, and Germantown:

| City | Highest 2 Priority_Incident (based on total count of incidents in a city) |
|------|--------------------------------------------------------------------------|
| Silver Spring | 1: SUSPICIOUS CIRC, PERSON, VEHICLE (8%) <br> 2: TRAFFIC/TRANSPORTATION INCIDENT (6.6%) |
| Rockville | 1: CHECK WELFARE (5.5%) <br> 2: TRESPASSING/UNWANTED (5.5%) |
| Gaithersburg | 1: SUSPICIOUS CIRC, PERSON, VEHICLE (22.3%) <br> 2: TRAFFIC/TRANSPORTATION INCIDENT (18.2%) |
| Germantown | 1: SUSPICIOUS CIRC, PERSON, VEHICLE (8.9%) <br> 2: STATION RESPONSE (9.9%) |

- A significantly higher percentage of ‘1: SUSPICIOUS CIRC, PERSON, VEHICLE’ and ‘2: TRAFFIC/TRANSPORTATION INCIDENT’ combinations occur in Gaithersburg.
- Germantown has a notably high percentage of ‘2: STATION RESPONSE,’ which is not among the top 3 in any other city.

## Limitations: 
- Due to charges associated with pulling large number of records from the API call and processing them on AWS, the number of records for this project was limited to 1157.

## Future Improvements:
- Query on more data in June to see incidents across Montgomery county. 
- Add more data to the analysis to see if patterns have changed 
- From the analysis of Q6, do the particular combination of initia_type and disposition_Desc occur on specific streets/road addresses in Silver spring based on the map.
- Time of day, week of day analyse of incidents.

## Author & Acknowledgement: 
- Author: [Jeff Mathew Sam](https://www.linkedin.com/in/jeffmathewsam/)
- Deepest gratitude to David Fretag](https://github.com/dkfreitag) for his invaluable assistance throughout the course

## License
This project is licensed under the MIT License.


