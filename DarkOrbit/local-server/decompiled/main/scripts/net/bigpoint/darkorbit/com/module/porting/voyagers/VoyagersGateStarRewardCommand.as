package net.bigpoint.darkorbit.com.module.porting.voyagers
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   import net.bigpoint.darkorbit.com.module.ModuleFactory;
   import net.bigpoint.darkorbit.com.module.porting.events.*;
   
   public class VoyagersGateStarRewardCommand implements IModule
   {
      
      private static var _instance:VoyagersGateStarRewardCommand;
      
      public var star2Loots:Vector.<LootProbabilityModule>;
      
      public var star3Loots:Vector.<LootProbabilityModule>;
      
      public var instanceLevel:int = 0;
      
      public var star1Loots:Vector.<LootProbabilityModule>;
      
      public function VoyagersGateStarRewardCommand(param1:int = 0, param2:Vector.<LootProbabilityModule> = null, param3:Vector.<LootProbabilityModule> = null, param4:Vector.<LootProbabilityModule> = null)
      {
         super();
         if(param3 == null)
         {
            this.star2Loots = new Vector.<LootProbabilityModule>();
         }
         else
         {
            this.star2Loots = param3;
         }
         if(param4 == null)
         {
            this.star3Loots = new Vector.<LootProbabilityModule>();
         }
         else
         {
            this.star3Loots = param4;
         }
         this.instanceLevel = param1;
         if(param2 == null)
         {
            this.star1Loots = new Vector.<LootProbabilityModule>();
         }
         else
         {
            this.star1Loots = param2;
         }
      }
      
      public static function get instance() : VoyagersGateStarRewardCommand
      {
         return _instance || (_instance = new VoyagersGateStarRewardCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -28722;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 16;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:LootProbabilityModule = null;
         var _loc5_:LootProbabilityModule = null;
         var _loc6_:LootProbabilityModule = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.star2Loots.length > 0)
         {
            this.star2Loots.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = LootProbabilityModule(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.star2Loots.push(_loc4_);
            _loc2_++;
         }
         while(this.star3Loots.length > 0)
         {
            this.star3Loots.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc5_ = LootProbabilityModule(ModuleFactory.get().createInstance(param1.readShort()));
            _loc5_.read(param1);
            this.star3Loots.push(_loc5_);
            _loc2_++;
         }
         this.instanceLevel = param1.readInt();
         this.instanceLevel = this.instanceLevel >>> 9 % 32 | this.instanceLevel << 32 - 9 % 32;
         while(this.star1Loots.length > 0)
         {
            this.star1Loots.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc6_ = LootProbabilityModule(ModuleFactory.get().createInstance(param1.readShort()));
            _loc6_.read(param1);
            this.star1Loots.push(_loc6_);
            _loc2_++;
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:LootProbabilityModule = null;
         var _loc3_:LootProbabilityModule = null;
         var _loc4_:LootProbabilityModule = null;
         param1.writeShort(-28722);
         param1.writeByte(this.star2Loots.length);
         for each(_loc2_ in this.star2Loots)
         {
            _loc2_.write(param1);
         }
         param1.writeByte(this.star3Loots.length);
         for each(_loc3_ in this.star3Loots)
         {
            _loc3_.write(param1);
         }
         param1.writeInt(this.instanceLevel << 9 % 32 | this.instanceLevel >>> 32 - 9 % 32);
         param1.writeByte(this.star1Loots.length);
         for each(_loc4_ in this.star1Loots)
         {
            _loc4_.write(param1);
         }
      }
   }
}

