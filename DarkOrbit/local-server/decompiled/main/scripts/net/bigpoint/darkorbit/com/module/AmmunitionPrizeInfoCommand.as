package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class AmmunitionPrizeInfoCommand implements IModule
   {
      
      private static var _instance:AmmunitionPrizeInfoCommand;
      
      public var ammunitionPrizeItemList:Vector.<AmmunitionPrizeItem>;
      
      public function AmmunitionPrizeInfoCommand(param1:Vector.<AmmunitionPrizeItem> = null)
      {
         super();
         if(param1 == null)
         {
            this.ammunitionPrizeItemList = new Vector.<AmmunitionPrizeItem>();
         }
         else
         {
            this.ammunitionPrizeItemList = param1;
         }
      }
      
      public static function get instance() : AmmunitionPrizeInfoCommand
      {
         return _instance || (_instance = new AmmunitionPrizeInfoCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 40;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:AmmunitionPrizeItem = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.ammunitionPrizeItemList.length > 0)
         {
            this.ammunitionPrizeItemList.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = AmmunitionPrizeItem(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.ammunitionPrizeItemList.push(_loc4_);
            _loc2_++;
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:AmmunitionPrizeItem = null;
         param1.writeShort(40);
         param1.writeByte(this.ammunitionPrizeItemList.length);
         for each(_loc2_ in this.ammunitionPrizeItemList)
         {
            _loc2_.write(param1);
         }
      }
   }
}

