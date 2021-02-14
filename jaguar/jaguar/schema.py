import graphene
from clients.schema import ClientsQueries

class Query(
  ClientsQueries,
  graphene.ObjectType
):
  hello = graphene.String(default_value="Hi!")

schema = graphene.Schema(query=Query)