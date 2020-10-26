from django.shortcuts import render
from rest_framework.views import APIView
from rest_framework.response import Response

# create your views here

class CommentsView(APIView):

    def get(self, request, post_id):
        comments_list = []
        context = {'comments_list': comments_list}
        return Response(context)

    def post(self, request, post_id):
        context = {
            'comment_id':'5',
	        'message':'Comment successdully added.'
        }
        return Response(context)
    
    def delete(self, request, comment_id):
        context = {'message':'Comment successfully deleted.'}
        return Response(context)

    # TODO: Put zmieniona ścieżka
    def put(self, request, comment_id):
        context = {'message':'Comment successfully updated.'}
        return Response(context)


class ReactionsView(APIView):
    
    def get(self, request, post_id):
        reactions_list = []
        context = {'reactions_list': reactions_list}
        return Response(context)

    def post(self, request, post_id):
        context = {'message':'Reaction successdully added.'}
        return Response(context)
    
    def delete(self, request, post_id):
        context = {'message':'Reaction successfully deleted.'}
        return Response(context)
