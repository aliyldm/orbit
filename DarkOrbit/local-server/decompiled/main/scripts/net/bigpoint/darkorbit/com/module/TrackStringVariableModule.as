package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   
   public class TrackStringVariableModule extends TrackVariableModule
   {
      
      private static var _instance:TrackStringVariableModule;
      
      public var value:String = "";
      
      public function TrackStringVariableModule(param1:String = "", param2:String = "")
      {
         super(param1);
         this.value = param2;
      }
      
      public static function get instance() : TrackStringVariableModule
      {
         return _instance || (_instance = new TrackStringVariableModule());
      }
      
      override public function getLibcomModuleId() : int
      {
         return -8057;
      }
      
      override public function getLibcomModuleEstimatedLength() : int
      {
         return 2;
      }
      
      override public function read(param1:IDataInput) : void
      {
         param1.readShort();
         super.read(param1);
         this.value = param1.readUTF();
      }
      
      override public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-8057);
         super.write(param1);
         param1.writeUTF(this.value);
      }
   }
}

