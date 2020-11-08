from diagrams import Cluster, Diagram
from diagrams.azure.database import SQLDatabases
from diagrams.generic.database import SQL
from diagrams.programming.language import Python, R

with Diagram("Data Quality Model", show=False, outformat="jpg"):
    dm = SQLDatabases("Data Model")
    sample = SQL("Sample")
    metadata = SQLDatabases("Metadata")
    QA = SQL("Quality Assessment")

    with Cluster("Source"):
        source = [metadata, dm, sample]
        dm >> metadata 
        dm >> sample


    with Cluster("Sample Analysis"):
        SA = sample >> Python("Sample metrics") >> R("Statistical analysis")
    
    with Cluster("Analysis"):
        dm >> Python("Analysis") >> QA
        metadata >> Python("Analysis") >> QA
    
    with Cluster("Quality assessment"):
        SA >> QA

    QA >> SQL("Quality report")

    
