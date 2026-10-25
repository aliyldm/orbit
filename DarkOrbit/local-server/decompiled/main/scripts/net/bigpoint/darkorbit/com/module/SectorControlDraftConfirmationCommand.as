package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class SectorControlDraftConfirmationCommand implements IModule
   {
      
      private static var _instance:SectorControlDraftConfirmationCommand;
      
      public var seconds:int = 0;
      
      public function SectorControlDraftConfirmationCommand(param1:int = 0)
      {
         super();
         this.seconds = param1;
      }
      
      public static function get instance() : SectorControlDraftConfirmationCommand
      {
         return _instance || (_instance = new SectorControlDraftConfirmationCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 7124;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.seconds = param1.readInt();
         this.seconds = this.seconds << 13 % 32 | this.seconds >>> 32 - 13 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(7124);
         param1.writeInt(this.seconds >>> 13 % 32 | this.seconds << 32 - 13 % 32);
      }
   }
}

