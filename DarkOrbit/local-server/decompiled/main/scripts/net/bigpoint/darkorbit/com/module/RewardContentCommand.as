package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class RewardContentCommand implements IModule
   {
      
      private static var _instance:RewardContentCommand;
      
      public static const REWARDTYPE_PVP_SUMMER_EVENT_MILESTONE:int = 0;
      
      public static const REWARDTYPE_TIERED_ARENA_EVENT_PARTICIPATION:int = 1;
      
      public static const REWARDTYPE__MAX:int = 2;
      
      public var rewardContentModuleList:Vector.<RewardContentModule>;
      
      public var rewardType:int = 0;
      
      public function RewardContentCommand(param1:Vector.<RewardContentModule> = null, param2:int = 0)
      {
         super();
         if(param1 == null)
         {
            this.rewardContentModuleList = new Vector.<RewardContentModule>();
         }
         else
         {
            this.rewardContentModuleList = param1;
         }
         this.rewardType = param2;
      }
      
      public static function get instance() : RewardContentCommand
      {
         return _instance || (_instance = new RewardContentCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -6548;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:RewardContentModule = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.rewardContentModuleList.length > 0)
         {
            this.rewardContentModuleList.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = RewardContentModule(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.rewardContentModuleList.push(_loc4_);
            _loc2_++;
         }
         this.rewardType = param1.readShort();
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:RewardContentModule = null;
         param1.writeShort(-6548);
         param1.writeByte(this.rewardContentModuleList.length);
         for each(_loc2_ in this.rewardContentModuleList)
         {
            _loc2_.write(param1);
         }
         param1.writeShort(this.rewardType);
      }
   }
}

