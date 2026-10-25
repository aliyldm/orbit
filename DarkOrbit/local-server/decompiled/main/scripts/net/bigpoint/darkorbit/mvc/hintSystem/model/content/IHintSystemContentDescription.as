package net.bigpoint.darkorbit.mvc.hintSystem.model.content
{
   import net.bigpoint.darkorbit.mvc.hintSystem.model.vo.HintSystemContentVO;
   
   public interface IHintSystemContentDescription
   {
      
      function get content() : HintSystemContentVO;
      
      function get contentName() : String;
      
      function set id(param1:uint) : void;
      
      function get id() : uint;
      
      function set playistAsXML(param1:XML) : void;
      
      function get playistAsXML() : XML;
      
      function set viewStructureAsXML(param1:XML) : void;
      
      function get viewStructureAsXML() : XML;
      
      function getViewStructureResKey(param1:String = "default") : String;
      
      function isViewStructureLoaded() : Boolean;
      
      function set viewStructureLoadStatus(param1:Boolean) : void;
      
      function get sortOrder() : int;
      
      function set wasOpenedFromArchive(param1:Boolean) : void;
      
      function get wasOpenedFromArchive() : Boolean;
      
      function get closeHintWindowOnMapJump() : Boolean;
   }
}

