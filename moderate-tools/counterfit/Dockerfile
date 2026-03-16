FROM python:3.10-slim

# Pin compatible versions
RUN pip install --no-cache-dir \
    "flask<2.3" \
    "werkzeug<2.3" \
    counterfit

ENTRYPOINT ["counterfit"]
