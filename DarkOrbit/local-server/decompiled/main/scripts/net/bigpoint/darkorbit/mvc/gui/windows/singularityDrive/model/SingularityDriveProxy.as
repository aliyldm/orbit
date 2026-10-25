package net.bigpoint.darkorbit.mvc.gui.windows.singularityDrive.model
{
   import flash.utils.Dictionary;
   import net.bigpoint.darkorbit.com.module.UnstableAttributeModule;
   import net.bigpoint.darkorbit.com.module.porting.lockattributeitem.LockAttributeItemModule;
   import net.bigpoint.darkorbit.mvc.application.GameFacade;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.model.SimpleWindowProxy;
   
   public class SingularityDriveProxy extends SimpleWindowProxy
   {
      
      public static const NAME:String = "SingularityDriveProxy";
      
      public var viewData:SingularityDriveData = new SingularityDriveData();
      
      private var _lockData:Dictionary = new Dictionary();
      
      public function SingularityDriveProxy()
      {
         super(NAME);
      }
      
      public static function getProxy() : SingularityDriveProxy
      {
         var _loc1_:SingularityDriveProxy = GameFacade.getInstance().retrieveProxy(SingularityDriveProxy.NAME) as SingularityDriveProxy;
         if(!_loc1_)
         {
            _loc1_ = new SingularityDriveProxy();
            GameFacade.getInstance().registerProxy(_loc1_);
         }
         return _loc1_;
      }
      
      public function setViewData(param1:Vector.<LockAttributeItemModule>, param2:Boolean) : void
      {
         this.viewData.update(param1,param2);
      }
      
      public function getVIewData() : SingularityDriveData
      {
         return this.viewData;
      }
      
      public function setLockData(param1:Number, param2:Vector.<int>) : void
      {
         this._lockData[param1] = param2;
      }
      
      public function getLockDataByItemID(param1:Number) : Vector.<int>
      {
         return this._lockData[param1] = this._lockData[param1] || new Vector.<int>();
      }
      
      public function getMaxLockByItemId(param1:Number) : int
      {
         var _loc5_:UnstableAttributeModule = null;
         var _loc2_:LockAttributeItemModule = this.viewData.getModuleByItemId(param1);
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         while(_loc4_ < _loc2_.attributes.length)
         {
            _loc5_ = _loc2_.attributes[_loc4_];
            if(_loc5_.attribute != "" && _loc5_.boostValue != 0)
            {
               _loc3_ += 1;
            }
            _loc4_++;
         }
         return _loc3_;
      }
   }
}

