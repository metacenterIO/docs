> Security

Metacenter keeps a high degree of security for all customer data. 

## Information Security & Retention
All data within Metacenter uses symmetric encryption at rest (AES-256). 
Data retention is automatically managed. All data is purged according to the following timelines.


|Type   |Retention   |
|:-|:-|
|Raw Data   |12 months after last updated date.   |
|Analytics   |12 months after creation   |
|Summaries   |24 months after creation   |
|User Data   |Can be deleted anytime through the interface (except the last user on the account).   |

## Transport
All communications are encrypted end-to-end with a TLS-encrypted TCP connection.

## Authentication
### Users
Upon successful authentication to Metacenter, users are authenticated for up to 24 hours.

<b style="color:red">Deletion</b> of a User will immediately remove access to Metacenter.

### Agents
Agents use JWT (JSON Web Tokens) for authentication to Metacenter.
Refresh Tokens allow Service Accounts to receive a new token.
Tokens expire on a short rotating interval.

<b style="color:red">Deletion</b> of a Service Account will immediately remove access to Metacenter.


## Requests
Every request to Metacenter is validated against both a token and an identity. 
A token alone, even a valid one will not allow requests to data without a valid user.


