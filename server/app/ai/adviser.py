import os

from app.schemas.product import ProductScored
from ollama import chat


class Adviser:
    def __init__(self, model: str = "mistral:latest"):
        self.model = model
        # ðŸ”‘ IMPORTANT : Docker / local compatible
        os.environ.setdefault(
            "OLLAMA_HOST", os.getenv("OLLAMA_HOST", "http://ollama:11434")
        )

    def generate_advice(self, products: list[ProductScored]) -> str:
        if not products:
            return "No products to compare."

        products_str = "\n".join(
            [
                f"- {p.name} (Price: {p.price}, Score: {p.score}, Provider: {p.provider}, Stock: {p.in_stock}, Description: {p.description})"
                for p in products
            ]
        )

        prompt = (
            f"Comparez les produits suivants et sÃ©lectionnez le meilleur en fonction du score et des caractÃ©ristiques. "
            f"Expliquez pourquoi c'est le gagnant. Soyez concis et rÃ©pondez en franÃ§ais.\n\n{products_str}"
        )

        try:
            response = chat(
                model=self.model,
                messages=[
                    {"role": "user", "content": prompt},
                ],
            )
            return response["message"]["content"]
        except Exception as e:
            print(f"Error generating advice: {e}")
            return "Sorry, I couldn't generate advice at this time."
