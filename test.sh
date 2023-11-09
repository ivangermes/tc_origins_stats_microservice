HOST="http://0.0.0.0:8082"

set -x
curl -i -w "\n\n" -X GET  "$HOST/health"

curl -i -w "\n\n" -X GET  "$HOST/v1/origins_stats"

curl -i -w "\n\n" -X GET  "$HOST/v1/origins_stats?time_from=2023-04-06T23:27:54.000Z&time_to=2023-04-08T07:11:04.000Z"

curl -i -w "\n\n" -X GET  "$HOST/v1/origins_stats?time_from=2023-04-06T23:27:54.000Z"

curl -i -w "\n\n" -X GET  "$HOST/v1/origins_stats?time_to=2023-04-08T07:11:04.000Z"

curl -i -w "\n\n" -X GET  "$HOST/v1/origins_stats?time_from=2023-04-06&time_to=2023-04-08"

curl -i -w "\n\n" -X GET  "$HOST/v1/origins_stats?time_from=2023-04-08T07:11:04.000Z&time_to=2023-04-06T23:27:54.000Z"

curl -i -w "\n\n" -X GET  "$HOST/v1/origins_stats?time_to=2023-99-08T07:11:04.000Z"