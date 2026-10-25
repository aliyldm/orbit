package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class UIMinimapNoiseCommand implements IModule
   {
      
      private static var _instance:UIMinimapNoiseCommand;
      
      public var duration:int = 0;
      
      public function UIMinimapNoiseCommand(param1:int = 0)
      {
         super();
         this.duration = param1;
      }
      
      public static function get instance() : UIMinimapNoiseCommand
      {
         return _instance || (_instance = new UIMinimapNoiseCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 115;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.duration = param1.readInt();
         this.duration = this.duration >>> 8 % 32 | this.duration << 32 - 8 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(115);
         param1.writeInt(this.duration << 8 % 32 | this.duration >>> 32 - 8 % 32);
      }
   }
}

