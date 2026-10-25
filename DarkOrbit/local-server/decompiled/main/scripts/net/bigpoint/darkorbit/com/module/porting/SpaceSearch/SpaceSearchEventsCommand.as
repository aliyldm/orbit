package net.bigpoint.darkorbit.com.module.porting.SpaceSearch
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   import net.bigpoint.darkorbit.com.module.*;
   
   public class SpaceSearchEventsCommand implements IModule
   {
      
      private static var _instance:SpaceSearchEventsCommand;
      
      public var rewards:Vector.<RewardModule>;
      
      public var eventIds:Vector.<EventCommand>;
      
      public var planets:Vector.<PlanetCommand>;
      
      public function SpaceSearchEventsCommand(param1:Vector.<EventCommand> = null, param2:Vector.<PlanetCommand> = null, param3:Vector.<RewardModule> = null)
      {
         super();
         if(param3 == null)
         {
            this.rewards = new Vector.<RewardModule>();
         }
         else
         {
            this.rewards = param3;
         }
         if(param1 == null)
         {
            this.eventIds = new Vector.<EventCommand>();
         }
         else
         {
            this.eventIds = param1;
         }
         if(param2 == null)
         {
            this.planets = new Vector.<PlanetCommand>();
         }
         else
         {
            this.planets = param2;
         }
      }
      
      public static function get instance() : SpaceSearchEventsCommand
      {
         return _instance || (_instance = new SpaceSearchEventsCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -22757;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 12;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:RewardModule = null;
         var _loc5_:EventCommand = null;
         var _loc6_:PlanetCommand = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.rewards.length > 0)
         {
            this.rewards.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = RewardModule(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.rewards.push(_loc4_);
            _loc2_++;
         }
         while(this.eventIds.length > 0)
         {
            this.eventIds.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc5_ = EventCommand(ModuleFactory.get().createInstance(param1.readShort()));
            _loc5_.read(param1);
            this.eventIds.push(_loc5_);
            _loc2_++;
         }
         while(this.planets.length > 0)
         {
            this.planets.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc6_ = PlanetCommand(ModuleFactory.get().createInstance(param1.readShort()));
            _loc6_.read(param1);
            this.planets.push(_loc6_);
            _loc2_++;
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:RewardModule = null;
         var _loc3_:EventCommand = null;
         var _loc4_:PlanetCommand = null;
         param1.writeShort(-22757);
         param1.writeByte(this.rewards.length);
         for each(_loc2_ in this.rewards)
         {
            _loc2_.write(param1);
         }
         param1.writeByte(this.eventIds.length);
         for each(_loc3_ in this.eventIds)
         {
            _loc3_.write(param1);
         }
         param1.writeByte(this.planets.length);
         for each(_loc4_ in this.planets)
         {
            _loc4_.write(param1);
         }
      }
   }
}

