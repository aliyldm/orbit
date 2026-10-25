package net.bigpoint.darkorbit.com.module.porting.activityevent.returnofhero
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class EventReturnOfHeroContributorCommand implements IModule
   {
      
      private static var _instance:EventReturnOfHeroContributorCommand;
      
      public var count:int = 0;
      
      public var name:String = "";
      
      public function EventReturnOfHeroContributorCommand(param1:String = "", param2:int = 0)
      {
         super();
         this.count = param2;
         this.name = param1;
      }
      
      public static function get instance() : EventReturnOfHeroContributorCommand
      {
         return _instance || (_instance = new EventReturnOfHeroContributorCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -30534;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 6;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.count = param1.readInt();
         this.count = this.count >>> 7 % 32 | this.count << 32 - 7 % 32;
         this.name = param1.readUTF();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-30534);
         param1.writeInt(this.count << 7 % 32 | this.count >>> 32 - 7 % 32);
         param1.writeUTF(this.name);
      }
   }
}

