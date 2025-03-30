# parent-repo

This is a git repository that holds both our frontend and backend repositories as submodules.

## Installation

To clone this repository and all its submodules, run:

```bash
./update_all.sh
```


## Usage

To run both the frontend and backend server, run:

```bash
./run.sh
```
However, environment variables must be set for both.


### Frontend .env
```env

AUTH0_SECRET=
APP_BASE_URL=
AUTH0_DOMAIN=
AUTH0_CLIENT_ID=
AUTH0_CLIENT_SECRET=


PLAID_CLIENT_ID=
PLAID_SECRET=
PLAID_ENV=

MONGODB_URI=mongodb://localhost:27017
MONGODB_DB=frontend-server

BACKEND_URI=http://localhost:8080

NEXT_PUBLIC_KNOTAPI_CLIENT_ID=
KNOTAPI_CLIENT_SECRET=
```

### Backend .env
```env
API_ADDR=0.0.0.0
API_PORT=8080
DB_HOST=
DB_PORT=
DB_USER=postgres
DB_PASS=pillow123
DB_NAME=roots
NESSIE_KEY=
GEMINI_KEY=
```
