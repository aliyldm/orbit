package net.bigpoint.darkorbit.com.module.porting.activityevent.returnofhero
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   import net.bigpoint.darkorbit.com.module.ModuleFactory;
   
   public class EventReturnOfHeroContributorListCommand implements IModule
   {
      
      private static var _instance:EventReturnOfHeroContributorListCommand;
      
      public var contributorList:Vector.<EventReturnOfHeroContributorCommand>;
      
      public function EventReturnOfHeroContributorListCommand(param1:Vector.<EventReturnOfHeroContributorCommand> = null)
      {
         super();
         if(param1 == null)
         {
            this.contributorList = new Vector.<EventReturnOfHeroContributorCommand>();
         }
         else
         {
            this.contributorList = param1;
         }
      }
      
      public static function get instance() : EventReturnOfHeroContributorListCommand
      {
         return _instance || (_instance = new EventReturnOfHeroContributorListCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 20608;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:EventReturnOfHeroContributorCommand = null;
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
            _loc4_ = EventReturnOfHeroContributorCommand(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.contributorList.push(_loc4_);
            _loc2_++;
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:EventReturnOfHeroContributorCommand = null;
         param1.writeShort(20608);
         param1.writeByte(this.contributorList.length);
         for each(_loc2_ in this.contributorList)
         {
            _loc2_.write(param1);
         }
      }
   }
}

