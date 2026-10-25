package net.bigpoint.darkorbit.lazyload
{
   import net.bigpoint.as3toolbox.filecollection.event.FileCollectionFileLoadEvent;
   import net.bigpoint.as3toolbox.filecollection.finish.SWFFinisher;
   import net.bigpoint.darkorbit.managers.ResourceManager;
   
   public class LazyLoadVO
   {
      
      public var callbackCompleteList:Array = [];
      
      public var callbackErrorList:Array = [];
      
      public var isLoaded:Boolean = false;
      
      private var _inProgress:Boolean = false;
      
      private var resKey:String;
      
      public function LazyLoadVO(param1:String, param2:Function, param3:Function)
      {
         super();
         this.resKey = param1;
         this.addCompleteCallback(param2);
         this.addErrorCallback(param3);
      }
      
      public function load() : void
      {
         this._inProgress = true;
         if(!ResourceManager.fileCollection.isLoaded(this.resKey))
         {
            ResourceManager.fileCollection.load(this.resKey,this.assetLoaded,this.assetLoadError);
         }
      }
      
      public function assetLoaded(param1:SWFFinisher = null) : void
      {
         this._inProgress = false;
         this.isLoaded = true;
         this.callAllCompleteCallbacks(param1);
      }
      
      public function assetLoadError(param1:FileCollectionFileLoadEvent = null) : void
      {
         this._inProgress = false;
         ResourceManager.removeLazyLoaderObject(this.resKey);
         this.callAllErrorCallbacks();
      }
      
      public function callAllCompleteCallbacks(param1:SWFFinisher = null) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < this.callbackCompleteList.length)
         {
            this.callbackCompleteList[_loc2_](param1);
            _loc2_++;
         }
         this.callbackCompleteList.length = 0;
      }
      
      public function callAllErrorCallbacks() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this.callbackErrorList.length)
         {
            this.callbackErrorList[_loc1_]();
            _loc1_++;
         }
         this.callbackErrorList.length = 0;
      }
      
      public function addCompleteCallback(param1:Function) : void
      {
         this.callbackCompleteList.push(param1);
      }
      
      public function addErrorCallback(param1:Function) : void
      {
         this.callbackErrorList.push(param1);
      }
      
      public function get inProgress() : Boolean
      {
         return this._inProgress;
      }
   }
}

