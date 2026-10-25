package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class KeepAlive implements IModule
   {
      
      private static var _instance:KeepAlive;
      
      public var MouseClick:Boolean = false;
      
      public function KeepAlive(param1:Boolean = false)
      {
         super();
         this.MouseClick = param1;
      }
      
      public static function get instance() : KeepAlive
      {
         return _instance || (_instance = new KeepAlive());
      }
      
      public function getLibcomModuleId() : int
      {
         return 2;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 1;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.MouseClick = param1.readBoolean();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(2);
         param1.writeBoolean(this.MouseClick);
      }
   }
}

