package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class FrozenLabyrinthKeyInfoCommand implements IModule
   {
      
      private static var _instance:FrozenLabyrinthKeyInfoCommand;
      
      public var labyrinthKeys:int = 0;
      
      public function FrozenLabyrinthKeyInfoCommand(param1:int = 0)
      {
         super();
         this.labyrinthKeys = param1;
      }
      
      public static function get instance() : FrozenLabyrinthKeyInfoCommand
      {
         return _instance || (_instance = new FrozenLabyrinthKeyInfoCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 29323;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.labyrinthKeys = param1.readInt();
         this.labyrinthKeys = this.labyrinthKeys << 3 % 32 | this.labyrinthKeys >>> 32 - 3 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(29323);
         param1.writeInt(this.labyrinthKeys >>> 3 % 32 | this.labyrinthKeys << 32 - 3 % 32);
      }
   }
}

