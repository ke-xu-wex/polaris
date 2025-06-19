#/bin/bash

export CLIENT_ID=root
export CLIENT_SECRET=s3cr3t

./polaris catalogs create \
  --storage-type s3 \
  --default-base-location ${DEFAULT_BASE_LOCATION} \
  --role-arn ${ROLE_ARN} \
  quickstart_catalog


  polaris catalogs create \
    --storage-type s3 \
    --default-base-location s3://wex-datalake-aws-dev-us-west-2-l8f886ok \
    --allowed-location s3://wex-datalake-aws-dev-us-west-2-l8f886ok-test/locallog \
    --role-arn arn:aws:iam::975049916663:role/snowflake-open-catalog-role-dc8r1vkn \
    s3-test-catalog

  export CLIENT_ID=root
  export CLIENT_SECRET=s3cr3t
  export CATALOG_NAME=s3-test-catalog

  ./polaris \
    principals \
    create \
    test_user

  ./polaris \
    --client-id ${CLIENT_ID} \
    --client-secret ${CLIENT_SECRET} \
    principal-roles \
    create \
    test_user_role

  ./polaris \
    --client-id ${CLIENT_ID} \
    --client-secret ${CLIENT_SECRET} \
    principal-roles \
    grant \
    --principal test_user \
    test_user_role

  ./polaris \
    --client-id ${CLIENT_ID} \
    --client-secret ${CLIENT_SECRET} \
    principal-roles \
    grant \
    --principal root \
    test_user_role

  #================= setup a new catalog, for the same user ===================
  ./polaris \
    --client-id ${CLIENT_ID} \
    --client-secret ${CLIENT_SECRET} \
    catalogs \
    create \
    --storage-type file \
    --default-base-location file:///opt/spark/polaris-catalog-data \
    ${CATALOG_NAME}

  ./polaris \
    --client-id ${CLIENT_ID} \
    --client-secret ${CLIENT_SECRET} \
    catalog-roles \
    create \
    --catalog ${CATALOG_NAME} \
    ${CATALOG_NAME}_role

  ./polaris catalog-roles list \
    --catalog ${CATALOG_NAME}

  ./polaris \
    --client-id ${CLIENT_ID} \
    --client-secret ${CLIENT_SECRET} \
    catalog-roles \
    grant \
    --catalog ${CATALOG_NAME} \
    --principal-role test_user_role \
    ${CATALOG_NAME}_role

  ./polaris \
    --client-id ${CLIENT_ID} \
    --client-secret ${CLIENT_SECRET} \
    privileges \
    catalog \
    grant \
    --catalog ${CATALOG_NAME} \
    --catalog-role ${CATALOG_NAME}_role \
    CATALOG_MANAGE_CONTENT