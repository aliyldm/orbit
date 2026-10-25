package net.bigpoint.darkorbit.com.module.porting.auction
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class UpdateNamFIagCommand implements IModule
   {
      
      private static var _instance:UpdateNamFIagCommand;
      
      public var open:Boolean = false;
      
      public var success:Boolean = false;
      
      public function UpdateNamFIagCommand(param1:Boolean = false, param2:Boolean = false)
      {
         super();
         this.open = param2;
         this.success = param1;
      }
      
      public static function get instance() : UpdateNamFIagCommand
      {
         return _instance || (_instance = new UpdateNamFIagCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 498;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 2;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.open = param1.readBoolean();
         this.success = param1.readBoolean();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(498);
         param1.writeBoolean(this.open);
         param1.writeBoolean(this.success);
      }
   }
}

