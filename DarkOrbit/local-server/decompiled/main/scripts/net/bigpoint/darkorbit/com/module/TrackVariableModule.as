package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class TrackVariableModule implements IModule
   {
      
      private static var _instance:TrackVariableModule;
      
      public var key:String = "";
      
      public function TrackVariableModule(param1:String = "")
      {
         super();
         this.key = param1;
      }
      
      public static function get instance() : TrackVariableModule
      {
         return _instance || (_instance = new TrackVariableModule());
      }
      
      public function getLibcomModuleId() : int
      {
         return -2396;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 2;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.key = param1.readUTF();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-2396);
         param1.writeUTF(this.key);
      }
   }
}

