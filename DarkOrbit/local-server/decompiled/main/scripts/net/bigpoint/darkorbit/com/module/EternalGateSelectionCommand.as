package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class EternalGateSelectionCommand implements IModule
   {
      
      private static var _instance:EternalGateSelectionCommand;
      
      public var selectedOption:int = 0;
      
      public function EternalGateSelectionCommand(param1:int = 0)
      {
         super();
         this.selectedOption = param1;
      }
      
      public static function get instance() : EternalGateSelectionCommand
      {
         return _instance || (_instance = new EternalGateSelectionCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -3580;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.selectedOption = param1.readInt();
         this.selectedOption = this.selectedOption >>> 12 % 32 | this.selectedOption << 32 - 12 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-3580);
         param1.writeInt(this.selectedOption << 12 % 32 | this.selectedOption >>> 32 - 12 % 32);
      }
   }
}

