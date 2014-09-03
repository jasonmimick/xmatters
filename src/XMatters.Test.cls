class XMatters.Test extends %RegisteredObject
{

ClassMethod Test1() 
{
	do ##class(Ens.Config.Credentials).SetCredential("Default_System","_system","SYS",1)
	set operation = ##class(EnsLib.HTTP.GenericOperation).%New("DummyName")
	set sc = operation.OnInit()  
	set operation.Adapter.HTTPServer = "localhost"
	set operation.Adapter.HTTPPort = "10101"
	set operation.Adapter.Credentials = "Default_System"
	set json = ##class(%ZEN.proxyObject).%New()
	set json.scenario = "Test HealthShare"
	set json.recipients = ##class(%ListOfObjects).%New()
	set me = ##class(%ZEN.proxyObject).%New()
	set me.targetName = "jmimick"
	set me.devices = ##class(%ListOfDataTypes).%New()
	do me.devices.Insert("Email")
	do me.devices.Insert("Voice Phone")
	do json.recipients.Insert(me)
	set json.callbacks = ##class(%ListOfObjects).%New()
	set cb = ##class(%ZEN.proxyObject).%New()
	set cb.url = "http://exchange.healthshare.us:9999/xmatters/status"
	set cb.type = "status"
	do json.callbacks.Insert(cb)
	set request = ##class(EnsUtils.HTTP.Utils).CreateHTTPRequestWithJSONBody( json )
	do request.HTTPHeaders.SetAt("POST","httprequest")
	do request.HTTPHeaders.SetAt("application/json","content-type")
	write !,"Request Headers",!,"---------------",!
	do ##class(EnsUtils.HTTP.Utils).OutputArrayOfDataTypesToDevice( request.HTTPHeaders )
	write !
	write "Request Body",!,"------------",!
	while ( 'request.Stream.AtEnd ) {
		write request.Stream.Read()
	}
	do request.Stream.Rewind()
	do request.HTTPHeaders.SetAt(request.Stream.Size,"content-length")

	set sc = operation.OnMessage(request,.response)
	write !,"Response Headers",!,"---------------",!
	do ##class(EnsUtils.HTTP.Utils).OutputArrayOfDataTypesToDevice( request.HTTPHeaders )
	write !
	write "Response Body",!,"------------",!
	while ( 'response.Stream.AtEnd ) {
		write response.Stream.Read()
	}


}

}
