package net.bigpoint.darkorbit.com.module.porting.auction
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class GetNamFlagCommand implements IModule
   {
      
      private static var _instance:GetNamFlagCommand;
      
      public var open:Boolean = false;
      
      public function GetNamFlagCommand(param1:Boolean = false)
      {
         super();
         this.open = param1;
      }
      
      public static function get instance() : GetNamFlagCommand
      {
         return _instance || (_instance = new GetNamFlagCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 25086;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 1;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.open = param1.readBoolean();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(25086);
         param1.writeBoolean(this.open);
      }
   }
}

