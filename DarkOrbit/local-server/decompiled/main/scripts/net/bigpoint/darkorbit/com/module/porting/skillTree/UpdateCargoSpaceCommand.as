package net.bigpoint.darkorbit.com.module.porting.skillTree
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class UpdateCargoSpaceCommand implements IModule
   {
      
      private static var _instance:UpdateCargoSpaceCommand;
      
      public var cargoSpaceMax:int = 0;
      
      public function UpdateCargoSpaceCommand(param1:int = 0)
      {
         super();
         this.cargoSpaceMax = param1;
      }
      
      public static function get instance() : UpdateCargoSpaceCommand
      {
         return _instance || (_instance = new UpdateCargoSpaceCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -11155;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.cargoSpaceMax = param1.readInt();
         this.cargoSpaceMax = this.cargoSpaceMax >>> 10 % 32 | this.cargoSpaceMax << 32 - 10 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-11155);
         param1.writeInt(this.cargoSpaceMax << 10 % 32 | this.cargoSpaceMax >>> 32 - 10 % 32);
      }
   }
}

