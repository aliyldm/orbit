package net.bigpoint.darkorbit.com.module.porting.SpaceSearch
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   import net.bigpoint.darkorbit.com.module.ModuleFactory;
   
   public class SpaceSearchSectorRewardsCommand implements IModule
   {
      
      private static var _instance:SpaceSearchSectorRewardsCommand;
      
      public var rewards:Vector.<SpaceSearchSectorRewards>;
      
      public function SpaceSearchSectorRewardsCommand(param1:Vector.<SpaceSearchSectorRewards> = null)
      {
         super();
         if(param1 == null)
         {
            this.rewards = new Vector.<SpaceSearchSectorRewards>();
         }
         else
         {
            this.rewards = param1;
         }
      }
      
      public static function get instance() : SpaceSearchSectorRewardsCommand
      {
         return _instance || (_instance = new SpaceSearchSectorRewardsCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -10623;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:SpaceSearchSectorRewards = null;
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
            _loc4_ = SpaceSearchSectorRewards(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.rewards.push(_loc4_);
            _loc2_++;
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:SpaceSearchSectorRewards = null;
         param1.writeShort(-10623);
         param1.writeByte(this.rewards.length);
         for each(_loc2_ in this.rewards)
         {
            _loc2_.write(param1);
         }
      }
   }
}

