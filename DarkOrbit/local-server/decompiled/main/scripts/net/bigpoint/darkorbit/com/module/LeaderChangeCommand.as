package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class LeaderChangeCommand implements IModule
   {
      
      private static var _instance:LeaderChangeCommand;
      
      public var leaderId:int = 0;
      
      public function LeaderChangeCommand(param1:int = 0)
      {
         super();
         this.leaderId = param1;
      }
      
      public static function get instance() : LeaderChangeCommand
      {
         return _instance || (_instance = new LeaderChangeCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -15967;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.leaderId = param1.readInt();
         this.leaderId = this.leaderId << 14 % 32 | this.leaderId >>> 32 - 14 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-15967);
         param1.writeInt(this.leaderId >>> 14 % 32 | this.leaderId << 32 - 14 % 32);
      }
   }
}

