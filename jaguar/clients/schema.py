from graphene import relay, ObjectType
from graphene_django import DjangoObjectType
from graphene_django.filter import DjangoFilterConnectionField
from django.utils import timezone
from .models import Clients


class ClientsNode(DjangoObjectType):
    class Meta:
      model = Clients
      filter_fields = {
          'name': ['exact', 'icontains']
      }
      interfaces = (relay.Node,)


class ClientsQueries(ObjectType):
    all_clients = DjangoFilterConnectionField(ClientsNode)


"""E.G query
  query{
    allClients(
      first: 10
    ){
      edges{
        node{
          id
          name
        }
      }
    }
  }
"""