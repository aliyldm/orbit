package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class SeasonPassRewardInfoCommand implements IModule
   {
      
      private static var _instance:SeasonPassRewardInfoCommand;
      
      public var goldPassRewardItems:Vector.<SeasonPassRewardModule>;
      
      public var freeRewardItems:Vector.<SeasonPassRewardModule>;
      
      public var extGoldPassRewardItems:Vector.<SeasonPassRewardModule>;
      
      public function SeasonPassRewardInfoCommand(param1:Vector.<SeasonPassRewardModule> = null, param2:Vector.<SeasonPassRewardModule> = null, param3:Vector.<SeasonPassRewardModule> = null)
      {
         super();
         if(param2 == null)
         {
            this.goldPassRewardItems = new Vector.<SeasonPassRewardModule>();
         }
         else
         {
            this.goldPassRewardItems = param2;
         }
         if(param1 == null)
         {
            this.freeRewardItems = new Vector.<SeasonPassRewardModule>();
         }
         else
         {
            this.freeRewardItems = param1;
         }
         if(param3 == null)
         {
            this.extGoldPassRewardItems = new Vector.<SeasonPassRewardModule>();
         }
         else
         {
            this.extGoldPassRewardItems = param3;
         }
      }
      
      public static function get instance() : SeasonPassRewardInfoCommand
      {
         return _instance || (_instance = new SeasonPassRewardInfoCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -20276;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 12;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:SeasonPassRewardModule = null;
         var _loc5_:SeasonPassRewardModule = null;
         var _loc6_:SeasonPassRewardModule = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.goldPassRewardItems.length > 0)
         {
            this.goldPassRewardItems.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = SeasonPassRewardModule(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.goldPassRewardItems.push(_loc4_);
            _loc2_++;
         }
         while(this.freeRewardItems.length > 0)
         {
            this.freeRewardItems.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc5_ = SeasonPassRewardModule(ModuleFactory.get().createInstance(param1.readShort()));
            _loc5_.read(param1);
            this.freeRewardItems.push(_loc5_);
            _loc2_++;
         }
         while(this.extGoldPassRewardItems.length > 0)
         {
            this.extGoldPassRewardItems.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc6_ = SeasonPassRewardModule(ModuleFactory.get().createInstance(param1.readShort()));
            _loc6_.read(param1);
            this.extGoldPassRewardItems.push(_loc6_);
            _loc2_++;
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:SeasonPassRewardModule = null;
         var _loc3_:SeasonPassRewardModule = null;
         var _loc4_:SeasonPassRewardModule = null;
         param1.writeShort(-20276);
         param1.writeByte(this.goldPassRewardItems.length);
         for each(_loc2_ in this.goldPassRewardItems)
         {
            _loc2_.write(param1);
         }
         param1.writeByte(this.freeRewardItems.length);
         for each(_loc3_ in this.freeRewardItems)
         {
            _loc3_.write(param1);
         }
         param1.writeByte(this.extGoldPassRewardItems.length);
         for each(_loc4_ in this.extGoldPassRewardItems)
         {
            _loc4_.write(param1);
         }
      }
   }
}

