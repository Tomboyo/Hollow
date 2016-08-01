Sandbox is a simple REST server skeleton built atop Sinatra. It provides a dynamic routing configuration and simple a resource scheme for creating API servers that respond to requests of the form `HTTP_METHOD www.site.com/resource/?id`, where `resource` is an API resource capable of responding to requests and `id` is an optional parameter that uniquely identifies resource records.

An application built on Sandbox primarily relies on a collection of classes in the `/resources` folder (the location and name of which is arbitrary and configurable), each of which implement a *resource interface* that registers them within the application as being publicly available to service requests. Resources define methods named after HTTP method types, such as :get and :post, which are invoked by the application to respond to corresponding requests. For instance, a request to `GET /MyResource/5` triggers the application to invoke the :get method of the MyResource class. However, Sandbox applications will discriminate when doing so, rejecting requests that name non-existent resources or name classes that do not extend the `ResourceInterface` module. If a requested resource is valid, Sandbox applications will only invoke the HTTP-named methods of the resource, and then only if they are public, so that you may attach server-private functionality to your resource files. As implementors of the `ResourceInterface` contract, all resource classes come with some basic functionality provided by the module. Until you override the default functionality of a HTTP-named method of a resource, it will respond to requests with the following message:

    { "error": "The resource you requested can not respond to this request (see OPTIONS)" }

Do note that this message encourages your user to send an OPTIONS request to the resource to learn how to use the API, so make sure you override the :options method. Incidentally, it... also generates that message.

To launch your application, run `launch.rb`.

Config.yml
----------
This is the configuration file for your server. Sandbox allows you to configure which HTTP methods your resources are allowed to respond to by adjusting the items in the development.resource_methods array. If a method is not listed in this array, requests utilizing this method will garner a response prompting the user to send an OPTIONS request. The location of resources and other necessary system files may be added to the development.autorequire.directories array to further configure your system. Note that *any* folder may act as the "resources" folder, or many folders can act in this capacity. Thus, this is your means of deciding where your resources are (which are indicated to the system by extending the `ResourceInterface`, see below). The development environment configuration is the default from which test and production inherit, so changes made here will cascade to the other environments, as well. The provided config.yml has an overriding setup for the test environment, allowing different files to be included in the system for testing purposes.

    # Config.yml snippet showing the default development settings
    development: &common_settings
      autorequire:
        directories: [/resource]
      resource_methods: [get, post, put, patch, delete, options]

ResourceInterface
-----------------
This module is the interface which all resources in your system must implement. It provides no functionality other than defaulting every Resource::HTTP_METHOD call to raise a ResourceMethodInvalidEception, which is caught by Sandbox and returned to the user as the informative message we say earlier. Any class which implements ResourceInterface via extending the module is considered a resource by Sandbox and will have its public HTTP-named methods made available to service requests. Private and protected methods will not be available, and nor will any methods whose names do not match HTTP request methods (as configured in Config.yml). Any class which does not implement ResourceInterface will not be publicly accessible. Note that it is the act of extending `ResourceInterface` which makes a class a resource, *not* the virtue of being in a particular folder.

Sandbox Exceptions
------------------
Sandbox comes with three custom StdError classes: `ApplicationException`, `ResourceInvalidException`, and `ResourceMethodInvalidException`. The former is raised for generic user-error related issues, such as bad data payloads with invalid or missing parameters. There are meant for you to raise to send informative messages to the user, such as 'Missing ID' or 'A record with id 10 was not found', since Sandbox will rescue all such exceptions and package their message in a standardized error payload. ResourceInvalidExceptions and ResourceMethodInvalidExceptions are raised and rescued by Sandbox in order to standardize API messages reporting that a requested resource was not found or that it can not service a given request (because your Resource does not override the ResourceInterface for the given HTTP name).

Examples
--------
The `test/resource` folder contains two classes, Access and NoAccess. The former is a valid resource in the application and can be accessed via API calls to `GET /Access/id?`, where id may be any value or none at all. The static method Access::get will be invoked and the result parsed by Sandbox into JSON, which will respond to the request. NoAccess does NOT implement ResourceInterface, and so even though it is in the resources folder and included in the system, it will not be available under `METHOD /NoAccess/id?' for any METHOD or any id.

Gotchas
-------
- Resource names are case-sensitive in the API. A request to `/MyResource/` is different from a request to `/myResource/`.
- Resources should return data as it should appear within the `data` structure of the response payload. Sandbox will standardize the output of your resources so you don't need to do so yourself.
- Error messages should always be sent to the user via ApplicationException.new, not by returning a string within a resource. Sandbox will rescue these exceptions and package their messages into the `error` structure of the response payload.
- Internal server errors are reported via payloads with `internal_error` keys. The message sent back is entirely banal, but if your UI only listens for `data` and `error` but not `internal_error`, it may miss these responses and silently fail.
