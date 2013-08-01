;(function(namespace){

  function handleScript(elem, callback) {
    if (document.addEventListener) {
      elem.addEventListener('load', callback, false);
    } else {
      elem.attachEvent('onreadystatechange', function () {
        if (elem.readyState == 'loaded' || elem.readyState == 'complete') {
          callback();
        }else {
          callback(new Error('Error loading script'))
        }
      });
    }
  }

  function depends(src, callback) {
    var head = document.getElementsByTagName('head')[0];
    var script = document.createElement('script');
    script.setAttribute('src', src);
    script.setAttribute("type","text/javascript");
    script.setAttribute('async', true);
    handleScript(script, callback);
    head.appendChild(script);
  }

  if(! namespace['SockJS']) depends('//cdn.sockjs.org/sockjs-0.3.min.js', MuleBuilder )
  else MuleBuilder()

  function MuleBuilder(err) {

    if(err instanceof Error) { console.log("Could not load script"); return }

    function Mule(options){
      this.attempt = 1
      options = options || {}
      if(options.host) this.connect(options.host)
    }

    Mule.prototype.connect = function(host){
      this.transport  = new SockJS(host)
      this._registerCallbacks()
    }

    Mule.prototype._registerCallbacks = function(){
      var self = this
      
      this.transport.onopen = function(){
        console.log(arguments)
      }

      this.transport.onmessage = function(event){
        console.log(e)
      }

      this.transport.onclose = function() {
        if( self.attempt > 5 ) { console.log("Aborting attempt to reconnect after 5 retries"); return }
        self.attempt++
        var seconds = Math.pow(2, self.attempt) * 1000
        setTimeout( self.connect.bind(self), seconds)
      }

    }

    function Callbacker(){
      this._callbacks = {};
    }

    Callbacker.prototype.get = function(eventName){
      return this._callbacks[this._prefix(eventName)];
    }

    Callbacker.prototype.add = function(eventName, callback) {
      var prefixedEventName = this._prefix(eventName);
      this._callbacks[prefixedEventName] = this._callbacks[prefixedEventName] || [];
      this._callbacks[prefixedEventName].push(callback);
    }

    Callbacker.prototype.remove = function(eventName, callback) {
      if(this.get(eventName)) {
        for(var i = 0; i< this._callbacks.length; i++) {
          var index = Util.indexOf(this.get(eventName), callback);
        }
        this._callbacks[this._prefix(eventName)].splice(index, 1);
      }
    }

    Callbacker.prototype._prefix = function(eventName) {
      return "_" + eventName;
    };


    function EventEmitter(){
      this.listeners = new Callbacker() 
    }

    EventEmitter.prototype.bind = function(name, callback){
      this.listeners.add(name, callback)
      return this
    }

    EventEmitter.prototype.unbind = function(eventName, callback) {
      this.listeners.remove(eventName, callback);
      return this;
    };

    EventEmitter.prototype.emit = function(name, data){
      var callbacks = this.listeners.get(eventName);
      if (callbacks) {
        for (var i = 0; i < callbacks.length; i++) {
          callbacks[i](data);
        }
      } 
      return this;
    }

    Util = {
      indexOf: function(array, item){
        var nativeIndexOf = Array.prototype.indexOf;
        if (array == null) return -1;
        if (nativeIndexOf && array.indexOf === nativeIndexOf) return array.indexOf(item);
        for (i = 0, l = array.length; i < l; i++) if (array[i] === item) return i;
        return -1;
      }
    }

    namespace.Mule = Mule
  }
  
})(window)