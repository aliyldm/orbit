package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class JumpDeniedCommand implements IModule
   {
      
      private static var _instance:JumpDeniedCommand;
      
      public var mandatoryLevel:int = 0;
      
      public function JumpDeniedCommand(param1:int = 0)
      {
         super();
         this.mandatoryLevel = param1;
      }
      
      public static function get instance() : JumpDeniedCommand
      {
         return _instance || (_instance = new JumpDeniedCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 18;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.mandatoryLevel = param1.readInt();
         this.mandatoryLevel = this.mandatoryLevel >>> 6 % 32 | this.mandatoryLevel << 32 - 6 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(18);
         param1.writeInt(this.mandatoryLevel << 6 % 32 | this.mandatoryLevel >>> 32 - 6 % 32);
      }
   }
}

