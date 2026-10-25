package net.bigpoint.darkorbit.com.module.porting.trinitytrials
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   import net.bigpoint.darkorbit.com.module.ModuleFactory;
   import net.bigpoint.darkorbit.com.module.porting.*;
   
   public class TrinityTrialsRewardDescriptionCommand implements IModule
   {
      
      private static var _instance:TrinityTrialsRewardDescriptionCommand;
      
      public var rewardDescriptionList:Vector.<TupleThreeModule>;
      
      public function TrinityTrialsRewardDescriptionCommand(param1:Vector.<TupleThreeModule> = null)
      {
         super();
         if(param1 == null)
         {
            this.rewardDescriptionList = new Vector.<TupleThreeModule>();
         }
         else
         {
            this.rewardDescriptionList = param1;
         }
      }
      
      public static function get instance() : TrinityTrialsRewardDescriptionCommand
      {
         return _instance || (_instance = new TrinityTrialsRewardDescriptionCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 24874;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:TupleThreeModule = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.rewardDescriptionList.length > 0)
         {
            this.rewardDescriptionList.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = TupleThreeModule(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.rewardDescriptionList.push(_loc4_);
            _loc2_++;
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:TupleThreeModule = null;
         param1.writeShort(24874);
         param1.writeByte(this.rewardDescriptionList.length);
         for each(_loc2_ in this.rewardDescriptionList)
         {
            _loc2_.write(param1);
         }
      }
   }
}

