package net.bigpoint.darkorbit.com.module.porting.expedition
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class ExpeditionStartInstanceCommand implements IModule
   {
      
      private static var _instance:ExpeditionStartInstanceCommand;
      
      public var seconds:int = 0;
      
      public function ExpeditionStartInstanceCommand(param1:int = 0)
      {
         super();
         this.seconds = param1;
      }
      
      public static function get instance() : ExpeditionStartInstanceCommand
      {
         return _instance || (_instance = new ExpeditionStartInstanceCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -10149;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.seconds = param1.readInt();
         this.seconds = this.seconds << 9 % 32 | this.seconds >>> 32 - 9 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-10149);
         param1.writeInt(this.seconds >>> 9 % 32 | this.seconds << 32 - 9 % 32);
      }
   }
}

