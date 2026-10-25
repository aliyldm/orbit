package net.bigpoint.darkorbit.mvc.crafting.upgrade.model
{
   import org.osflash.signals.ISignal;
   import org.osflash.signals.Signal;
   
   public class UpgradeModel
   {
      
      public const changed:ISignal = new Signal();
      
      private var _availableUpgradeTypes:Vector.<UpgradeTypeModel> = new Vector.<UpgradeTypeModel>(0);
      
      public function UpgradeModel()
      {
         super();
      }
      
      public function get availableUpgradeTypes() : Vector.<UpgradeTypeModel>
      {
         return this._availableUpgradeTypes;
      }
      
      public function getUpgradeByTargetLootID(param1:String) : UpgradeTypeModel
      {
         var _loc4_:UpgradeTypeModel = null;
         var _loc2_:int = int(this.availableUpgradeTypes.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = this._availableUpgradeTypes[_loc3_];
            if(_loc4_.targetItemType.lootID == param1)
            {
               return _loc4_;
            }
            _loc3_++;
         }
         return null;
      }
      
      public function addType(param1:UpgradeTypeModel) : void
      {
         this.availableUpgradeTypes.push(param1);
         this.availableUpgradeTypes.sort(UpgradeTypeModel.sort);
      }
   }
}

