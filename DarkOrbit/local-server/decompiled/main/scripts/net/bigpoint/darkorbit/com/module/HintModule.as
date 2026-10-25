package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class HintModule implements IModule
   {
      
      private static var _instance:HintModule;
      
      public var replacements:Vector.<ReplacementModule>;
      
      public var messageKey:String = "";
      
      public function HintModule(param1:String = "", param2:Vector.<ReplacementModule> = null)
      {
         super();
         if(param2 == null)
         {
            this.replacements = new Vector.<ReplacementModule>();
         }
         else
         {
            this.replacements = param2;
         }
         this.messageKey = param1;
      }
      
      public static function get instance() : HintModule
      {
         return _instance || (_instance = new HintModule());
      }
      
      public function getLibcomModuleId() : int
      {
         return 19437;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 6;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:ReplacementModule = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.replacements.length > 0)
         {
            this.replacements.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = ReplacementModule(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.replacements.push(_loc4_);
            _loc2_++;
         }
         this.messageKey = param1.readUTF();
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:ReplacementModule = null;
         param1.writeShort(19437);
         param1.writeByte(this.replacements.length);
         for each(_loc2_ in this.replacements)
         {
            _loc2_.write(param1);
         }
         param1.writeUTF(this.messageKey);
      }
   }
}

