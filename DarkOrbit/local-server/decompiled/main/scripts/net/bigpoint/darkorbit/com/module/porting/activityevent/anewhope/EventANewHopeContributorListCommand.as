package net.bigpoint.darkorbit.com.module.porting.activityevent.anewhope
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   import net.bigpoint.darkorbit.com.module.ModuleFactory;
   
   public class EventANewHopeContributorListCommand implements IModule
   {
      
      private static var _instance:EventANewHopeContributorListCommand;
      
      public var contributorList:Vector.<EventANewHopeContributorCommand>;
      
      public function EventANewHopeContributorListCommand(param1:Vector.<EventANewHopeContributorCommand> = null)
      {
         super();
         if(param1 == null)
         {
            this.contributorList = new Vector.<EventANewHopeContributorCommand>();
         }
         else
         {
            this.contributorList = param1;
         }
      }
      
      public static function get instance() : EventANewHopeContributorListCommand
      {
         return _instance || (_instance = new EventANewHopeContributorListCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 10888;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:EventANewHopeContributorCommand = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.contributorList.length > 0)
         {
            this.contributorList.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = EventANewHopeContributorCommand(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.contributorList.push(_loc4_);
            _loc2_++;
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:EventANewHopeContributorCommand = null;
         param1.writeShort(10888);
         param1.writeByte(this.contributorList.length);
         for each(_loc2_ in this.contributorList)
         {
            _loc2_.write(param1);
         }
      }
   }
}

