package net.bigpoint.darkorbit.mvc.gui.windows.singularityDrive.model
{
   import net.bigpoint.darkorbit.com.module.porting.lockattributeitem.LockAttributeItemModule;
   import org.osflash.signals.ISignal;
   import org.osflash.signals.Signal;
   
   public class SingularityDriveData
   {
      
      private var _allModules:Vector.<LockAttributeItemModule> = new Vector.<LockAttributeItemModule>();
      
      public const dataChanged:ISignal = new Signal();
      
      public var availabled:Boolean = false;
      
      public function SingularityDriveData()
      {
         super();
      }
      
      private function updateList(param1:Vector.<LockAttributeItemModule>, param2:Boolean) : void
      {
         var _loc3_:int = 0;
         while(_loc3_ < param1.length)
         {
            this.updateModuleByItemID(param1[_loc3_].itemId,param1[_loc3_],param2);
            _loc3_++;
         }
      }
      
      public function update(param1:Vector.<LockAttributeItemModule>, param2:Boolean) : void
      {
         this.updateList(param1,param2);
         this.availabled = true;
         this.dataChanged.dispatch();
      }
      
      public function getModuleByItemId(param1:Number) : LockAttributeItemModule
      {
         var _loc3_:LockAttributeItemModule = null;
         var _loc2_:int = 0;
         while(_loc2_ < this._allModules.length)
         {
            _loc3_ = this._allModules[_loc2_];
            if(_loc3_.itemId == param1)
            {
               return _loc3_;
            }
            _loc2_++;
         }
         return null;
      }
      
      public function updateModuleByItemID(param1:Number, param2:LockAttributeItemModule, param3:Boolean) : void
      {
         var _loc6_:LockAttributeItemModule = null;
         var _loc4_:Boolean = true;
         var _loc5_:int = 0;
         while(_loc5_ < this._allModules.length)
         {
            _loc6_ = this._allModules[_loc5_];
            if(_loc6_.itemId == param1)
            {
               _loc4_ = false;
               if(param3)
               {
                  this._allModules.splice(_loc5_,1);
               }
               else
               {
                  this._allModules[_loc5_] = param2;
               }
            }
            _loc5_++;
         }
         if(_loc4_)
         {
            this._allModules.push(param2);
         }
      }
   }
}

