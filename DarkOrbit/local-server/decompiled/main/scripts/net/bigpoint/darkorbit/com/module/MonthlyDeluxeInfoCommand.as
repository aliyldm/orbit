package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class MonthlyDeluxeInfoCommand implements IModule
   {
      
      private static var _instance:MonthlyDeluxeInfoCommand;
      
      public var rewardList:Vector.<MonthlyDeluxeRewardModule>;
      
      public var dayInfoCommand:MonthlyDeluxeDayInfoCommand;
      
      public var timeInfoCommand:MonthlyDeluxeTimeInfoCommand;
      
      public function MonthlyDeluxeInfoCommand(param1:Vector.<MonthlyDeluxeRewardModule> = null, param2:MonthlyDeluxeTimeInfoCommand = null, param3:MonthlyDeluxeDayInfoCommand = null)
      {
         super();
         if(param1 == null)
         {
            this.rewardList = new Vector.<MonthlyDeluxeRewardModule>();
         }
         else
         {
            this.rewardList = param1;
         }
         if(param3 == null)
         {
            this.dayInfoCommand = new MonthlyDeluxeDayInfoCommand();
         }
         else
         {
            this.dayInfoCommand = param3;
         }
         if(param2 == null)
         {
            this.timeInfoCommand = new MonthlyDeluxeTimeInfoCommand();
         }
         else
         {
            this.timeInfoCommand = param2;
         }
      }
      
      public static function get instance() : MonthlyDeluxeInfoCommand
      {
         return _instance || (_instance = new MonthlyDeluxeInfoCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -7956;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:MonthlyDeluxeRewardModule = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.rewardList.length > 0)
         {
            this.rewardList.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = MonthlyDeluxeRewardModule(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.rewardList.push(_loc4_);
            _loc2_++;
         }
         this.dayInfoCommand = MonthlyDeluxeDayInfoCommand(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.dayInfoCommand)
         {
            this.dayInfoCommand.read(param1);
         }
         this.timeInfoCommand = MonthlyDeluxeTimeInfoCommand(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.timeInfoCommand)
         {
            this.timeInfoCommand.read(param1);
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:MonthlyDeluxeRewardModule = null;
         param1.writeShort(-7956);
         param1.writeByte(this.rewardList.length);
         for each(_loc2_ in this.rewardList)
         {
            _loc2_.write(param1);
         }
         if(null != this.dayInfoCommand)
         {
            this.dayInfoCommand.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         if(null != this.timeInfoCommand)
         {
            this.timeInfoCommand.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
      }
   }
}

